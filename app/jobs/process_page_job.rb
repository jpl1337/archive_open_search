class ProcessPageJob < ApplicationJob
  queue_as :default

  def perform(page_id, page_path)
    page = Page.find(page_id)
    page.update!(status: "processing")

    # convert pdf to image
    image_path = convert_pdf_to_image(page_path)

    extracted_text, confidence_score = run_ocr(image_path)

    page.update!(
      text_content: extracted_text,
      confidence_score: confidence_score,
      status: "completed",
      last_processed_at: Time.current
    )
  
  rescue => e
    page.update!(status: "error")
    Rails.logger.error "ProcessPageJob failed for Page #{page_id}: #{e.message}"
  ensure
    File.delete(image_path) if image_path && File.exist?(image_path)
  end

  private

  def run_ocr(page_path)
    image = RTesseract.new(page_path)
    extracted_text = image.to_s.strip

    confidence_score = estimate_confidence(extracted_text)
    return extracted_text, confidence_score
  end

  def estimate_confidence(text)
    # Add beter logic later...
    text.empty? ? 0 : 90
  end

  def convert_pdf_to_image(pdf_path, dpi = 300)
    image_path = "#{File.dirname(pdf_path)}/#{File.basename(pdf_path, ".pdf")}.png"

    MiniMagick::Tool::Convert.new do |convert|
      convert.density(dpi.to_s)
      convert.background("white")
      convert.alpha("remove")
      convert << pdf_path
      convert << image_path
    end
  image_path
  end
    
end

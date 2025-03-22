class DownloadAndSplitJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)

    document.update!(status: "downloading")

    pdf_file = download_pdf(document.source_url)

    sha256 = Digest::SHA256.file(pdf_file.path).hexdigest
    document.update!(sha256: sha256)

    pages = split_pdf(pdf_file.path)

    pages.each_with_index do |page_path, index|
      page = document.pages.create!(
        page_number: index + 1,
        status: "pending"
      )
      ProcessPageJob.perform_later(page.id, page_path)
    end

    document.update!(status: "processing")

  rescue => e
    Rails.logger.error "DownloadAndSplitJob failed for Document #{document_id}: #{e.message}"
    document.update!(status: "error") if document.present?

  ensure
    if pdf_file
      pdf_file.close
      pdf_file.unlink
    end
  end

  private

  def download_pdf(url)
    tmp_file = Temfile.new(["document", ".pdf"], binmode: true)

    URI.open(url) do |data|
      tmp_file.write(data.read)
    end

    tmp_file.rewind
    tmp_file
  end

  def split_pdf(file_path)
    output_dir = Dir.mktmpdir
    page_paths = []

    pdf = HexaPDF:Document.open(file_path)

    pdf.pages.each_with_index do |page, index|
      new_pdf = HexaPDF::Document.new
      new_pdf.pages.add(page)
      out_path = "#{output_dir}/page_#{index + 1}.pdf"

      new_pdf.write(out_path)

      page_paths << out_path
    end

    page_paths
  end

end

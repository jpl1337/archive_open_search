class Page < ApplicationRecord
    belongs_to :document

    after_save :update_document_status!
    pages = document.pages
    if pages.all? { |page| page.status == "completed"}
        document.update!(status: "completed")
    elsif pages.any? {|page| page.status == "error"}
        document.update!(status: "partial_error")
    elsif pages.any? {|page| page.status == "processing"}
        document.upate!(status: "processing")
    elsif pages.all? {|page| page.status == "error"}
        document.update!(status: "error")
    else
        document.upate!(status: "pending")
    validates :page_number, presence: true
    validates :status, inclusion: {in: %w[pending processing completed error] }
end
require "rails_helper"

RSpec.describe ProcessPageJob, type: :job do
    include FactoryBot::Syntax::Methods

    let(:page) { create(:page) }

    before do
        allow_any_instance_of(ProcessPageJob).to receive(:convert_pdf_to_image).and_return("/tmp/page_1.png")
        allow_any_instance_of(ProcessPageJob).to receive(:run_ocr).and_return(["Sample extracted text", 95])
    end

    it "processes a page and updates its content" do
        described_class.perform_now(page.id, "/tmp/page_1.pdf")
        page.reload

        expect(page.status).to eq("completed")
        expect(page.text_content).to include("Sample extracted text")
        expect(page.confidence_score).to eq(95)
    end

    it "sets status to error on failure" do
        allow_any_instance_of(ProcessPageJob).to receive(:run_ocr).and_raise(StandardError.new("OCR failed"))

        described_class.perform_now(page.id, "/tmp/page_1.pdf")

        page.reload
        expect(page.status).to eq("error")
    end
end
require "rails_helper"

RSpec.describe DownloadAndSplitJob, type: :job do
    include FactoryBot::Syntax::Methods

    let(:document) { create(:document, source_url: "https://example.com/test.pdf") }
    let(:tempfile) { Tempfile.new(["test",".pdf"])}
    before do
        allow_any_instance_of(DownloadAndSplitJob).to receive(:download_pdf).and_return(tempfile)
        allow_any_instance_of(DownloadAndSplitJob).to receive(:split_pdf).and_return(["/tmp/page_1.pdf"])
    end

    it "processes a document and queues page jobs" do
        expect {
            described_class.perform_now(document.id)
        }.to change { document.pages.count }.by(1)

    expect(document.reload.status).to eq("processing")
    end
end
class FetchJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
  end
end

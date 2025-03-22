json.extract! document, :id, :title, :source_url, :sha256, :content, :confidence_score, :status, :created_at, :updated_at
json.url document_url(document, format: :json)

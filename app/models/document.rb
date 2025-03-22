class Document < ApplicationRecord
    has_many :pages, dependent: :destroy

    validates :sha256, presence: true, uniqueness: true
    validates :source_url, presence: true
    validates :status, inclusion: {in: %w[pending downloading downloaded processing completed partial_error error] }
end

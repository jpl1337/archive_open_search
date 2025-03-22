FactoryBot.define do
    factory :document do
        title { "Test Document" }
        source_url {"https://example.com/test.pdf"}
        sha256 { SecureRandom.hex(32) }
        status { "pending" }
    end
end
FactoryBot.define do
    factory :page do
        document
        page_number { 1 }
        text_content { "Sample text" }
        confidence_score { 90 }
        status { "pending" }
    end
end
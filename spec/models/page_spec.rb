require "rails_helper"

RSpec.describe Page, type: :model do
    include FactoryBot::Syntax::Methods

    it "is valid with valid attributes" do
        page = build(:page)
        expect(page).to be_valid
    end

    it "is invalid without a document" do
        page = build(:page, document: nil)
        expect(page).to_not be_valid
    end
end
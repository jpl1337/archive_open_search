require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  setup do
    @document = documents(:one)
  end

  test "visiting the index" do
    visit documents_url
    assert_selector "h1", text: "Documents"
  end

  test "should create document" do
    visit documents_url
    click_on "New document"

    fill_in "Confidence score", with: @document.confidence_score
    fill_in "Content", with: @document.content
    fill_in "Sha256", with: @document.sha256
    fill_in "Source url", with: @document.source_url
    fill_in "Status", with: @document.status
    fill_in "Title", with: @document.title
    click_on "Create Document"

    assert_text "Document was successfully created"
    click_on "Back"
  end

  test "should update Document" do
    visit document_url(@document)
    click_on "Edit this document", match: :first

    fill_in "Confidence score", with: @document.confidence_score
    fill_in "Content", with: @document.content
    fill_in "Sha256", with: @document.sha256
    fill_in "Source url", with: @document.source_url
    fill_in "Status", with: @document.status
    fill_in "Title", with: @document.title
    click_on "Update Document"

    assert_text "Document was successfully updated"
    click_on "Back"
  end

  test "should destroy Document" do
    visit document_url(@document)
    click_on "Destroy this document", match: :first

    assert_text "Document was successfully destroyed"
  end
end

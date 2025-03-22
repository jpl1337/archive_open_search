class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :source_url
      t.string :sha256
      t.text :content
      t.integer :confidence_score
      t.string :status

      t.timestamps
    end
  end
end

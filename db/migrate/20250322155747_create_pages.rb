class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.references :document, null: false, foreign_key: true
      t.integer :page_number
      t.text :text_content
      t.integer :confidence_score
      t.string :status

      t.timestamps
    end
  end
end

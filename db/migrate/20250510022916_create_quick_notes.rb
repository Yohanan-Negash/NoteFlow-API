class CreateQuickNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quick_notes do |t|
      t.text :content
      t.datetime :expires_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

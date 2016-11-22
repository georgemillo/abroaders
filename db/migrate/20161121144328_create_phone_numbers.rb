class CreatePhoneNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :phone_numbers do |t|
      t.references :account, foreign_key: { on_delete: :cascade }, null: false
      t.string :number, null: false
      t.string :normalized_number, null: false, index: :true

      t.timestamps
    end

    reversible do |d|
      d.up do
        Account.where.not(phone_number: nil).find_each do |account|
          number = account.phone_number
          ::PhoneNumber::Create.(
            phone_number: {
              number:  number,
            },
            current_account: account,
          )
        end
      end
      d.down do
        PhoneNumber.each do |pn|
          pn.account.update!(phone_number: pn.number)
        end
      end
    end

    remove_column :accounts, :phone_number, :string
  end
end

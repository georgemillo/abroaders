require 'rails_helper'

RSpec.describe Account do
  example '#people_by_type' do
    # solo account
    account = create_account
    owner = account.owner
    expect(account.people_by_type('owner')).to eq [owner]

    expect { account.people_by_type('both') }.to raise_error(ArgumentError)
    expect { account.people_by_type('companion') }.to raise_error(ArgumentError)

    # invalid person type:
    expect { account.people_by_type('invalid') }.to raise_error(ArgumentError)

    # couples account
    companion = account.create_companion!(first_name: 'X')

    expect(account.people_by_type('owner')).to eq [owner]
    expect(account.people_by_type('companion')).to eq [companion]
    expect(account.people_by_type('both')).to eq [owner, companion]
  end

  example '#award_wallet?' do
    account = Account.new
    expect(account.award_wallet?).to be false
    account.build_award_wallet_user
    expect(account.award_wallet?).to be false
    account.award_wallet_user.loaded = true
    expect(account.award_wallet?).to be true
  end
end

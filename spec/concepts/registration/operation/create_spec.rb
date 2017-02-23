require 'rails_helper'

RSpec.describe Registration::Operation::Create do
  let(:op) { described_class }

  example 'signing up' do
    expect do
      result = op.(
        account: {
          email: 'TestAccount@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          first_name: 'Luke',
        },
      )
      expect(result.success?).to be true

      account = result['model']
      # Email must be saved in lowercase. This is because the uniqueness
      # validation on Account#email only checks against lowercase strings, so
      # we don't have to make a case-insensitive index on that column. If we
      # save non-lowercase emails, we may end up with duplicates!
      expect(account.email).to eq 'testaccount@example.com'
      expect(account.owner.first_name).to eq 'Luke'
    end.to change { Account.count }.by(1)
  end

  example 'stripping trailing whitespace' do
    result = op.(
      account: {
        email: '    Test@example.com   ',
        password:  'password123',
        password_confirmation: 'password123',
        first_name: '   Luke    ',
      },
    )
    expect(result.success?).to be true

    account = result['model']
    expect(account.email).to eq 'test@example.com'
    expect(account.owner.first_name).to eq 'Luke'
  end

  example 'when passwords dont match' do
    expect do
      result = op.(
        account: {
          email: 'test@example.com',
          password: ' password123',
          password_confirmation: 'PASSword123',
          first_name: 'Luke',
        },
      )
      expect(result.success?).to be false
    end.not_to change { Account.count }
  end

  example 'email address already taken' do
    result = op.(
      account: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation:  'password123',
        first_name: 'Paul',
      },
    )
    raise unless result.success? # sanity check

    expect do
      result = op.(
        account: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation:  'password123',
          first_name: 'Paul',
        },
      )
      expect(result.success?).to be false
    end.not_to change { Account.count }
  end

  example 'email address already taken by an admin' do
    result = op.(
      account: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation:  'password123',
        first_name: 'Paul',
      },
    )
    raise unless result.success? # sanity check

    expect do
      result = op.(
        account: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation:  'password123',
          first_name: 'Paul',
        },
      )
      expect(result.success?).to be false
    end.not_to change { Account.count }
  end

  example 'email already taken by admin' do
    create(:admin, email: 'test@example.com')

    expect do
      result = op.(
        account: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation:  'password123',
          first_name: 'Paul',
        },
      )
      expect(result.success?).to be false
    end.not_to change { Account.count }
  end
end

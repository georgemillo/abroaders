require "rails_helper"

describe Card do
  let(:card) { described_class.new }

  describe "#bank" do
    it "looks up and returns the Bank using bank_id" do
      card.bank_id = 1
      bank         = card.bank
      expect(bank).to eq Bank.find(1)
      expect(bank.name).to eq "Chase"
    end
  end

  describe "#bank_id=" do
    it "resets the memoized bank" do
      card.bank_id  = 1
      memoized_bank = card.bank
      card.bank_id  = 3
      expect(card.bank).not_to eq memoized_bank
    end
  end

  describe "#bank=" do
    let(:bank_0) { Bank.find(1) }
    let(:bank_1) { Bank.find(3) }

    it "sets the bank and bank_id" do
      card.bank = bank_0
      expect(card.bank_id).to eq bank_0.id
      expect(card.bank).to eq bank_0
    end

    it "resets any memoized bank" do
      card.bank = bank_0
      card.bank = bank_1
      expect(card.bank_id).to eq bank_1.id
      expect(card.bank).to eq bank_1
    end
  end

  describe "#identifier" do
    it "generates an identifier using the bank ID, code, and network" do
      card.bank_id = 1
      card.code    = "ABC"
      card.network = :visa
      card.bp      = :personal
      expect(card.identifier).to eq "01-ABC-V"
      # personal cards use odd-numbered bank numbers, business cards use
      # even-numbered ones:
      card.bp = :business
      expect(card.identifier).to eq "02-ABC-V"
      card.network = :amex
      expect(card.identifier).to eq "02-ABC-A"
      card.network = :mastercard
      expect(card.identifier).to eq "02-ABC-M"
      card.network = :unknown_network
      expect(card.identifier).to eq "02-ABC-?"
    end
  end
end
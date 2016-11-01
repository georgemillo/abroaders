require "rails_helper"

describe Bank do
  example ".find" do
    result = Bank.find(1)
    expect(result).to be_a(Bank)
    expect(result.id).to eq 1
  end

  example ".find_by" do
    bank = Bank.find_by(name: "Chase")
    expect(bank.name).to eq "Chase"
    expect(bank.id).to eq 1
  end

  example ".find_by_name" do
    expect(Bank.find_by_name("Chase")).to eq Bank.find_by(name: "Chase")
  end

  example ".all" do
    banks = Bank.all
    names = [
      "Chase", "Citibank", "Barclays", "American Express", "Capital One",
      "Bank of America", "US Bank", "Discover", "Diners Club", "SunTrust",
      "TD Bank", "Wells Fargo",
    ]
    expect(banks.length).to eq names.length
    expect(banks.map(&:name)).to match_array(names)
  end

  example "#name" do
    bank = Bank.find(1)
    expect(bank.name).to eq "Chase"
  end

  example "#personal_phone" do
    bank = Bank.find_by_name("Chase")
    expect(bank.personal_phone).to eq "(888) 609-7805"
  end

  example "#business_phone" do
    bank = Bank.find_by_name("Chase")
    expect(bank.business_phone).to eq "800 453-9719"
  end

  example "#cards" do
    cards = create_list(:card, 2, bank_id: 1)
    create(:card, bank_id: 3) # for other bank
    expect(Bank.find(1).cards).to match_array(cards)
  end

  it "can be used as a hash key" do
    bank = Bank.find(1)

    hash = {}

    hash[bank] = "foo"
    hash[bank] = "bar"
    hash[bank] = "buzz"

    expect(hash.keys).to eq [bank]
    expect(hash[bank]).to eq "buzz"
  end

  example "#==" do
    b_0 = Bank.find(1)
    b_1 = Bank.find(1)
    b_2 = Bank.find(3)
    expect(b_0 == b_1).to be true
    expect(b_0 == b_2).to be false
  end

  example "#attributes" do
    bank = Bank.find(1)
    expect(bank.attributes).to eq(
      "id" => 1,
      "name" => "Chase",
      "personal_phone" => "(888) 609-7805",
      "business_phone" => "800 453-9719",
    )
  end
end
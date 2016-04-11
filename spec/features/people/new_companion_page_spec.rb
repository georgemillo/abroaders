require "rails_helper"

describe "new companion page" do
  subject { page }

  let!(:account) { create(:account) }
  let!(:me) { create(:person, account: account) }

  before do
    create(:person, main: false, account: account) if already_has_companion
    login_as_account(account)
    visit new_companion_path
  end

  let(:already_has_companion) { false }

  context "when I already have a companion" do
    let(:already_has_companion) { true }
    it "redirects me to my dashboard" do
      expect(current_path).to eq root_path
    end
  end

  it "asks me if I want to add a companion" do
    expect(page).to have_field :companion_first_name
  end

  describe "clicking 'yes'" do
    let(:click_yes) { click_button "Add companion" }

    describe "after adding the companion's name" do
      let(:name) { "Steve" }
      before { fill_in :companion_first_name, with: name }

      let(:companion) { account.people.order("created_at ASC").last }

      it "creates a companion" do
        expect{click_yes}.to change{account.people.count}.by(1)
        expect(companion.first_name).to eq "Steve"
      end

      it "takes me to the spending info for the companion" do
        click_yes
        expect(current_path).to eq new_person_spending_info_path(companion)
      end

      context "with trailing whitespace" do
        let(:name) { "    Traily     " }

        it "strips trailing whitespace from the companion's name" do
          expect{click_yes}.to change{account.people.count}.by(1)
          expect(companion.first_name).to eq "Traily"
        end
      end
    end
  end

  describe "clicking 'no'" do
    let(:click_no) { click_link "No thanks - I don't want to add a companion" }

    it "doesn't create a companion" do
      expect{click_no}.not_to change{Person.count}
    end

    it "takes me to the readiness survey" do
      click_no
      expect(current_path).to eq survey_readiness_path
    end
  end

end

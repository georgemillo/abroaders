class Person < ApplicationRecord
  def companion?
    !owner
  end

  def has_recent_recommendation?
    return false if last_recommendations_at.nil?
    last_recommendations_at >= Time.current - 30.days
  end

  def type
    owner ? "owner" : "companion"
  end

  def onboarded_spending?
    !!spending_info&.persisted?
  end

  def onboarded?
    onboarded_eligibility? && onboarded_balances? && (
      (ineligible?) || (onboarded_cards? && onboarded_spending?)
    )
  end

  def can_receive_recommendations?
    onboarded? && eligible? && ready?
  end

  def status
    if self.ineligible?
      "Ineligible"
    elsif self.ready?
      "Ready"
    else
      "Eligible(NotReady)"
    end
  end

  concerning :Eligibility do
    def onboarded_eligibility?
      !eligible.nil?
    end

    def ineligible
      !eligible
    end
    alias_method :ineligible?, :ineligible
  end

  concerning :Readiness do
    def onboarded_readiness?
      !ready.nil?
    end

    def unready
      !ready?
    end
    alias_method :unready?, :unready
  end

  # Validations

  NAME_MAX_LENGTH = 50

  validates :account, uniqueness: { scope: :owner }

  # Associations

  belongs_to :account
  has_one :spending_info, dependent: :destroy
  has_many :card_accounts
  has_many :card_recommendations, -> { recommendations }, class_name: "CardAccount"
  has_many :cards, through: :card_accounts

  has_many :balances
  has_many :currencies, through: :balances

  # Callbacks

  auto_strip_attributes :first_name

  # Scopes

  scope :owner,      -> { where(owner: true) }
  scope :companion, -> { where(owner: false) }
end

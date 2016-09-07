class Currency < ApplicationRecord

  # Validations

  validates :name, presence: true, uniqueness: true
  validates :award_wallet_id, presence: true, uniqueness: true

  # Scopes

  scope :survey,        -> { where(shown_on_survey: true) }
  scope :not_on_survey, -> { where(shown_on_survey: false) }

end

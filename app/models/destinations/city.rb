class City < Destination
  validates :parent, presence: true

  validate :parent_is_country

  private

  def parent_is_country
    if parent.present? && parent.type.present? && parent.type != "Country"
      errors.add(:parent, "must be a country")
    end
  end
end

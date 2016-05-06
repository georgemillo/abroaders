module CardAccount::Statuses
  extend ActiveSupport::Concern

  # 'declined' means the user would not, or could not, apply for the card
  #            which we recommended to them.
  # 'denied' means that the user applied for the card, but the application
  #          was denied by the bank.
  #
  #
  # FLOW
  #
  # Here's the way which a card account may pass through the statuses:
  #
  # (statuses in brackets may be skipped. The boolean after the comma
  # is the value of the 'reconsidered' column.)
  #
  # recommended, false
  #     ├─▸ declined, false
  #     ├─▸ denied, false
  #     │     ├─▸ declined, true
  #     │     ├─▸ denied, true
  #     │     └─▸ open, true
  #     │           └─▸ closed, true
  #     └─▸ open, false
  #           └─▸ closed, false
  #
  # TODO confirm with Erik: in previous sketches, we had an extra
  # stage called 'pending_decision', but for the sake of simplicity
  # I've decided not to store it. Can we get away with this?


  # Note that the numeric keys of the statuses don't necessarily match
  # the order in which a card account flows throw the statuses, because
  # some statuses were added later in the app's development than others.
  STATUSES = {
    unknown:     0,
    recommended: 1,
    declined:    2,
    clicked:     3,
    applied:     7,
    denied:      4,
    open:        5,
    closed:      6,
  }


  included do
    enum status: STATUSES
    validates :decline_reason, presence: { if: :declined? }

    # The methods auto-generated by `enum` don't get overriden if you put the
    # overrides in the 'main' part of the module, only if you put them within
    # the 'included' block. What's up with that?

    def applied!
      update_attributes!(status: :applied, applied_at: Time.now)
    end

    def clicked!
      update_attributes!(status: :clicked, clicked_at: Time.now)
    end
  end

  def applied_at
    declined? ? nil : read_attribute(:applied_at)
  end

  def declined_at
    declined? ? read_attribute(:applied_at) : nil
  end

  def declined_at=(datetime)
    self.applied_at = datetime
  end

  def decline_with_reason!(reason)
    update_attributes!(
      applied_at: Time.now, status: :declined, decline_reason: reason
    )
  end

  concerning :SafetyChecks do
    def applyable?
      status == "recommended"
    end

    def declinable?
      status == "recommended"
    end

    def deniable?
      status == "recommended"
    end

    def openable?
      status == "recommended"
    end
    alias_method :acceptable?, :openable?
  end
end

class Balance < Balance.superclass
  module Cell
    # The top-level cell for the balances#index action.
    #
    # @!method self.call(account, opts = {})
    #   @param account [Account] the currently-logged in account. Make sure
    #     that the right associations are eager-loaded.
    class Index < Trailblazer::Cell
      property :people
      property :connected_to_award_wallet?
      property :award_wallet_user

      def show
        aw = cell(AwardWalletPanel, model)
        main = cell(BalanceTable, collection: people)
        "#{aw} #{main}"
      end
    end
  end
end

module AdminArea
  class AccountsController < AdminController
    # GET /admin/accounts
    def index
      person_assocs = [:spending_info]
      @accounts = Account.includes(
        :phone_number,
        people: person_assocs,
        owner: person_assocs,
        companion: person_assocs,
      ).order("email ASC")
      render cell(Accounts::Cell::Index, @accounts, page: params[:page])
    end

    # GET /admin/accounts/1
    def show
      @account = Account.find(params[:id])
      @cards   = @account.cards.select(&:persisted?)
      @recommendation = @account.cards.new
      # Use @account.cards here instead of @cards because
      # the latter is an Array, not a Relation (because of
      # `.select(&:persisted?)`)
      @products = CardProduct.where.not(id: @account.cards.select(:product_id))
    end

    def search
      run Accounts::Operation::Search
      @collection = result['collection']
    end
  end
end

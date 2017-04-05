class CardAccount < CardAccount.superclass
  # Setup the form for a new card account.
  #
  # This op is also nested within CardAccount::Create
  #
  # @!method self.call(params, options)
  #   @option params [Integer] product_id The user will select the product on
  #     /cards/new (which uses the SelectProduct op, not this op). Next they'll
  #     see the 'real' form on /products/:product_id/cards/new. The form will
  #     then post to /products/:product_id/cards, meaning that :product_id
  #     should *always* be present in the params for both New and Create.
  #   @option params [Hash] person_id (optional) the person who the new card
  #     account belongs to. For solo accounts, the input won't be shown on the
  #     form, meaning this param won't be included. When person_id isn't
  #     specified, the person defaults to the account's owner.
  #   @option params [Hash] card the attributes of the new card account. See
  #     the form object for the required keys.
  #   @option options [Account] account the currently logged-in account
  class New < Trailblazer::Operation
    extend Contract::DSL
    contract Form

    step :setup_person!
    step :setup_model!
    success :find_product!
    step Contract::Build()

    private

    def setup_person!(opts, params:, account:, **)
      if params[:person_id]
        opts['person'] = account.people.find(params[:person_id])
      else
        opts['person'] = account.owner
      end
    end

    def find_product!(opts, params:, **)
      product_id = params.fetch(:product_id)
      opts['model'].product = CardProduct.find(product_id)
    end

    def setup_model!(opts, person:, **)
      opts['model'] = person.card_accounts.new
    end

    # when no product ID is provided in the params, show this page instead so
    # they can choose a product.
    class SelectProduct < Trailblazer::Operation
      step :load_products!
      step :load_banks!

      private

      def load_products!(opts)
        opts['collection'] = CardProduct.includes(:bank).order(name: :asc)
      end

      def load_banks!(opts)
        opts['banks'] = Bank.order(name: :asc)
      end
    end
  end
end
class CardProduct < ApplicationRecord
  module Cell
    # Takes a card product and returns a pretty name for it
    #
    # options:
    #   with_bank: default false. if true, result includes bank's name. If
    #     bank name is American Express, don't include it (because the network
    #     will also be AmEx, so the words 'American Express' will already be
    #     included in the name.
    #   network_in_brackets: default false. Wrap the name of the network
    #     in brackets, e.g. 'Chase Sapphire (Visa)'
    class FullName < Trailblazer::Cell
      property :bank
      property :bp
      property :name

      delegate :name, to: :bank, prefix: true

      def show
        parts = [name]
        parts.unshift(bank_name) if options[:with_bank]
        parts.push('business') if bp == 'business'
        # Amex will already be displayed as the bank name, so don't be redundant
        parts.push(network) unless exclude_network?
        parts.join(' ')
      end

      private

      def network
        name = cell(Network, model)
        if options[:network_in_brackets]
          "(#{name})"
        else
          name
        end
      end

      def exclude_network?
        model.network == 'unknown_network' || (bank_name == 'American Express' && options[:with_bank])
      end
    end
  end
end
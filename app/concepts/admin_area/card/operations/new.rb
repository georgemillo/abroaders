module AdminArea
  module Card
    module Operations
      class New < Trailblazer::Operation
        extend Contract::DSL
        contract ::Card::NewForm

        step :setup_person!
        step :setup_model!
        step Contract::Build()

        # This isn't pretty... also, it's display logic, so not sure it belongs
        # in here. FIXME
        def self.product_options
          ::Card::Product.all.map do |product|
            [::Card::Product::Identifier.new(product).to_s, product.id]
          end.sort_by { |p| p[0] }
        end

        private

        def setup_person!(opts, params:, **)
          opts['person'] = Person.find(params[:person_id])
        end

        def setup_model!(opts)
          opts['model'] = ::Card.new(person: opts['person'])
        end
      end
    end
  end
end

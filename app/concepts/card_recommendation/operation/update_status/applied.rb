class CardRecommendation < CardRecommendation.superclass
  module Operation
    module UpdateStatus
      class Applied < Trailblazer::Operation
        success :setup_model
        step :rec_can_be_applied_for?
        failure :log_rec_unapplyable
        step :mark_rec_as_applied

        private

        def setup_model(opts, account:, params:, **)
          opts['model'] = account.card_recommendations.find(params.fetch(:id))
        end

        def rec_can_be_applied_for?(model:, **)
          model.applyable?
        end

        def log_rec_unapplyable(opts)
          opts['error'] = I18n.t('cards.invalid_status_error')
        end

        def mark_rec_as_applied(model:, **)
          CardApplication.create!(applied_on: Date.today, card_recommendation: model)
        end
      end
    end
  end
end
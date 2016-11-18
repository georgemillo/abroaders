module Card::ProductsHelper
  def card_bp_filter_check_box_tag(bp)
    klass =  :card_bp_filter
    id    =  :"#{klass}_#{bp}"
    label_tag id do
      check_box_tag(
        id,
        nil,
        true,
        class: klass,
        data: { key: :bp, value: bp },
      ) << raw("&nbsp;&nbsp#{bp.capitalize}")
    end
  end

  def options_for_card_network_select(selected_network)
    options_for_select(
      Card::Product.networks.map do |network, _|
        [t("activerecord.attributes.card_product.networks.#{network}"), network]
      end,
      selected_network,
    )
  end

  def options_for_card_type_select(selected_type)
    options_for_select(
      Card::Product.types.map do |type, _|
        [t("activerecord.attributes.card_product.types.#{type}"), type]
      end,
      selected_type,
    )
  end
end

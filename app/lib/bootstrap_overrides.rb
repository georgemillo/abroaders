# Extend ActionView form helpers so that they automatically add a bootstrap
# 'form-control' CSS class to the generated <input> or <select> tag.
#
# Note that this module isn't included by default in cells - you must include
# it manually.
module BootstrapOverrides
  BOOTSTRAP_CLASS = 'form-control'.freeze

  # Add Bootstrap classes to form elements by default.
  # See stackoverflow.com/a/18844246/1603071
  [
    :text_field, :email_field, :password_field, :text_area,
    :text_field_tag, :number_field, :number_field_tag,
  ].each do |meth|
    define_method(meth) do |name, value = nil, options = {}|
      # the parent `number_field_tag` method calls text_field_tag - but it
      # stringifies the `option` keys first. So we need to make sure that keys
      # are symbolized.
      options.symbolize_keys!
      options[:class] = add_class(options[:class], BOOTSTRAP_CLASS)
      super(name, value, options)
    end
  end

  def submit_tag(value = nil, options = {})
    options[:class] = add_class(options[:class], "btn")
    super
  end

  def button_tag(content_or_options = nil, options = nil, &block)
    if content_or_options.is_a? Hash
      options = content_or_options
    else
      options ||= {}
    end
    options[:class] = add_class(options[:class], "btn")
    super
  end

  def select(object, method, choices = nil, options = {}, html_options = {}, &block)
    html_options[:class] = add_class(html_options[:class], BOOTSTRAP_CLASS)
    super
  end

  def select_tag(name, option_tags = nil, options = {})
    options[:class] = add_class(options[:class], BOOTSTRAP_CLASS)
    super
  end

  def collection_select(
    object,
    method,
    collection,
    value_method,
    text_method,
    options = {},
    html_options = {}
  )
    html_options[:class] = add_class(html_options[:class], BOOTSTRAP_CLASS)
    super
  end

  def date_select(object_name, method, options = {}, html_options = {})
    html_options[:class] = add_class(html_options[:class], BOOTSTRAP_CLASS)
    super
  end

  private

  def add_class(classes, new_class)
    if classes.nil?
      classes = new_class
    elsif " #{classes} ".index(" #{new_class} ").nil?
      classes << " #{new_class}"
    end
    classes
  end
end

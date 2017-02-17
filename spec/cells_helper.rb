# I've tried to find a way of testing cells without having to load the
# entire rails environment every time, but there are two major barriers:
#
# 1. rspec-cells depends on Rails
# 2. almost all cells are contained under the namespace of an ActiveRecord model, e.g.
#
#     class Flight < Flight.superclass
#       module Cell
#         class Summary < Trailblazer::Cell
#         ...
#
#   There's no way to load that without loading `Flight`, and, as I've
#   discovered before, because of the way activerecord associations work I
#   basically can't load Flight without loading every other model. Bollocks
require 'rails_helper'

# Cells shouldn't read from or write to the database. This hack, active only
# during cell specs, will raise an error if you try to save anything to the DB
# - which will force you to create Cells that don't read from the DB if you
# want your tests to pass
ApplicationRecord.class_eval do
  cattr_accessor :__is_cell_spec
  before_save :__disable_db_for_cell_specs

  private

  def __disable_db_for_cell_specs
    raise 'Cells must not touch the DB' if self.class.__is_cell_spec
  end
end

module Abroaders
  module RSpec
    module CapybaraRaw
      # The 'cell' method provided by rspec-cells will wrap the rendered string
      # in a Capybara::Node::Simple so that you can test it with matchers like
      # have_selector etc. This is fine, but sometimes a cell renders a really
      # simple string and you just want to test what that string equals.
      # Capybara::Simple::Node.to_s will include a bunch of extra shit like a
      # <doctype> and <body> tags. This hack adds the method #raw to the result
      # of `cell`, which you can use to get the original, unadultered result of
      # Cell#show, as a String.
      def raw
        body = all('body')[0]
        return '' if body.nil?
        body = body.native
        if body.children.count == 1 && body.children[0].name == 'p'
          body.children[0].inner_html
        else
          body.inner_html
        end
      end
    end

    module CellMacros
      def show(model = nil, opts = {})
        rendered = cell(described_class, model, opts).()
        rendered.extend(CapybaraRaw) if ::Cell::Testing.capybara?
        rendered
      end
    end
  end
end

module Cell::Testing::Capybara
end

# This is a heavily-modified version of the RSpec.configure block that's
# included by the `rspec-cells` gem:
RSpec.configure do |config|
  CELL_FILE_PATH = /\bcells?\b/

  config.include RSpec::Cells::ExampleGroup, file_path: CELL_FILE_PATH
  config.include RSpec::Cells::ExampleGroup, type: :cell
  # this must go below RSpec::Cells::ExampleGroup so our overrides work:
  config.include Abroaders::RSpec::CellMacros, file_path: CELL_FILE_PATH
  config.include Abroaders::RSpec::CellMacros, type: :cell

  Cell::Testing.capybara = true

  config.around do |example|
    metadata = example.metadata
    if metadata[:type] == :cell || metadata[:file_path] =~ CELL_FILE_PATH
      ApplicationRecord.__is_cell_spec = true
      example.run
      ApplicationRecord.__is_cell_spec = false
    else
      example.run
    end
  end
end
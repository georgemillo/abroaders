module AdminArea::Admins
  module Cell
    class Index < Abroaders::Cell::Base
      include Escaped

      private

      def link_to_add_new
        link_to 'Create new admin', new_admin_admin_path
      end
    end
  end
end

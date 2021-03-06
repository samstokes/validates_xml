module ActiveRecord
  module Validations
    module ClassMethods
      def validates_well_formed_xml(*attr_names)
        configuration = { :message => I18n.translate('activerecord.errors.messages')[:invalid], 
                          :on => :save, 
                          :with => nil }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
        validates_each(attr_names, configuration) do |record, attr_name, value|
          begin
            REXML::Document.new("<base>#{value}</base>")
          rescue REXML::ParseException => ex
            record.errors.add(attr_name, 
                              "is not well-formed xml.  #{ex.continued_exception}")
          end
        end
      end
    end   
  end
end

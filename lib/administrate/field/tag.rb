require "administrate/field/base"
require "rails"

include ActionView::Helpers::NumberHelper

module Administrate
  module Field
    class Tag < Administrate::Field::Base
      VERSION = "0.0.1"

      class Engine < ::Rails::Engine
        initializer 'tag.assets' do |app|
          app.config.assets.precompile += %w( administrate-field-tag/application.js )
          Administrate::Engine.add_javascript 'administrate-field-tag/application'

          Administrate::ApplicationController.before_action({ only: [:create, :update]}) do
            dashboard.form_attributes.each do |name|
              attribute_type = dashboard.attribute_type_for(name)
              if attribute_type == Administrate::Field::Tag
                tags = params[resource_name].delete(name).reject(&:blank?)
                params[resource_name]["#{name.to_s.singularize}_ids"] = tags.map do |tag|
                  Tag.find_or_create_by(name: tag.humanize).id
                end
              elsif attribute_type.is_a?(Administrate::Field::Deferred) and attribute_type.deferred_class == Administrate::Field::Tag
                tags = params[resource_name].delete(name).reject(&:blank?)
                params[resource_name]["#{name.to_s.singularize}_ids"] = tags.map do |tag|
                  attribute_type.options.fetch(:class_name, "Tag").constantize.find_or_create_by(attribute_type.options.fetch(:attribute_name, :name) => tag.humanize).id
                end
              end
            end
          end
        end
      end

      def self.permitted_attribute(attribute, options=nil)
        { "#{attribute.to_s.singularize}".to_sym => [] }
      end

      def attribute_key
        permitted_attribute.keys.first
      end

      def associated_resource_options
        associated_class.all.map { |resource| resource.send(attribute_name) }.flatten
      end

      def selected_options
        # data #&& data.map { |object| object.send(attribute_name) }
        data.map(&:to_s)

      end

      def permitted_attribute
        self.class.permitted_attribute(attribute)
      end

      def to_s
        (data && data.map { |object| object.send(attribute_name) }.join(', ')) || ""
      end

      private

      def associated_class
        associated_class_name.constantize
      end

      def associated_class_name
        options.fetch(:class_name, "Tag")
      end

      def attribute_name
        options.fetch(:attribute_name, :name)
      end
    end
  end
end

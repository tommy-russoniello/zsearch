class ApplicationController < ActionController::Base
  def index
    instance_variable_set(
      "@#{model_class.model_name.plural}",
      model_class.order(model_class.name_field)
    )
  end

  def model_class
    @model_class ||= controller_name.classify.safe_constantize
  end

  def search
    return if params[:fields].blank?

    @parameter = params[:search]&.downcase
    @results = model_class.all

    if @parameter.blank?
      nil_search_on_fields
    else
      search_on_fields
    end

    @results = @results.order(model_class.name_field).uniq
  end

  def show
    instance_variable_set("@#{model_class.model_name.singular}", model_class.find(params[:id]))
  end

  private

  def nil_search_on_fields
    params[:fields].each do |field, _|
      @results =
        if model_class.has_many_attributes.include?(field)
          @results.left_outer_joins(field.pluralize.to_sym)
            .where(field.pluralize.to_sym => { id: nil })
        else
          @results.where(field => [nil, ''])
        end
    end
  end

  def search_on_fields
    params[:fields].each do |field, _|
      temp_parameter = @parameter
      if model_class.boolean_attributes.include?(field)
        if temp_parameter == 'true'
          temp_parameter = 1
        elsif temp_parameter == 'false'
          temp_parameter = 0
        end
      elsif model_class.enum_attributes.include?(field)
        enum_num = model_class.send(field.pluralize)[temp_parameter.tr(' ', '_')]
        temp_parameter = enum_num if enum_num
      elsif model_class.has_many_attributes.include?(field)
        @results = @results.joins(field.pluralize.to_sym)
          .where("lower(#{field.pluralize}.name) LIKE ?", "%#{temp_parameter}%")
        next
      end

      @results = @results.where("lower(#{model_class.model_name.plural}.#{field}) LIKE ?",
        "%#{temp_parameter}%")
    end
  end
end

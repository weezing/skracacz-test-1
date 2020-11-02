class ValidationSerializer # rubocop:disable Metrics/ClassLength
  attr_reader :object

  def initialize(object, other_meta = {})
    @object = object
    @other_meta = other_meta || {}
  end

  def errors
    return [] unless object.respond_to?(:errors)

    attribute_errors
  end

  private

  def attribute_errors
    [].tap do |errors|
      each_error do |attribute, message, code|
        error = {
          code:   422,
          status: 'unprocessable_entity',
          title: 'Validation Error',
          detail: detail_for(attribute, message),
          source: { pointer: pointer_for(object, attribute) },
          meta:   meta_for(attribute, message, code).merge(@other_meta)
        }

        errors << error
      end
    end
  end

  def each_error
    object.errors.messages.each_pair do |attribute, messages|
      details = if Rails::VERSION::MAJOR >= 5
                  object.errors.details&.find { |k, _| k == attribute }&.dig(1)
                end

      messages.each_with_index do |message, index|
        code = details[index][:error] if details
        yield attribute, message, code
      end
    end
  end

  def detail_for(attribute, message)
    detail = object.errors.full_message(attribute, message)
    detail = message if attribute.to_s.casecmp('base').zero?
    detail
  end

  def pointer_for(_object, name)
    if attribute?(name)
      "/data/attributes/#{name}"
    elsif name == :base
      nil
    else
      # Probably a nested relation, like post.comments
      "/data/relationships/#{name}"
    end
  end

  def attribute?(name)
    object.respond_to?(name)
  end

  def meta_for(attribute, message, code)
    meta = {
      attribute: attribute,
      message: message
    }
    meta[:code] = code if Rails::VERSION::MAJOR >= 5

    meta
  end
end

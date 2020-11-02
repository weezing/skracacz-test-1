class Api::V1::CreateLinkService
  attr_reader :link, :error

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?

    create_link
  rescue ActiveRecord::RecordInvalid => error
    @error = 'Unable to create link'

    false
  end

  private

  attr_reader :form

  def create_link
    @link = Link.create!(form.attributes)
  end
end

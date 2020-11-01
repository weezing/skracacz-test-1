class Api::V1::CreateLinkService
  attr_reader :link, :params

  def initialize(params)
    @params = params
  end

  def call
    @link = Link.new(params)

    return false unless @link.valid?

    @link.save
  end
end

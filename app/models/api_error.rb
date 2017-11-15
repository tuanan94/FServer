class APIError
  attr_accessor :error
  def initialize(error_msg)
    self.error = error_msg
  end
end
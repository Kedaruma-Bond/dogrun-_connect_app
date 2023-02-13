class ApplicationViewComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include ApplicationHelper
  include DogHelper
  include SessionHelper
  include Dry::Effects.Reader(:current_user, default: nil)
end

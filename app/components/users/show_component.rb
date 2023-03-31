# frozen_string_literal: true

class Users::ShowComponent < ApplicationViewComponent
  def initialize(
      title:, 
      dogrun_place:,
      current_user:, 
      dogs:, 
      num_of_encount_dogs:, 
      form_selection_path:,
      dog_registration_path:,
      new_registration_number_path:,
      rns_form_selection_path:
    )
    @title = title
    @dogrun_place = dogrun_place
    @current_user = current_user
    @dogs = dogs
    @num_of_encount_dogs = num_of_encount_dogs
    @form_selection_path = form_selection_path
    @dog_registration_path = dog_registration_path
    @new_registration_number_path = new_registration_number_path
    @rns_form_selection_path = rns_form_selection_path
  end

end

class UserFullyRegistration
  include ActiveModel::Model
  attr_accessor :name, :email, :deactivation, :password, :password_confirmation, 
                :agreement, :zip_code, :address_1, :address_2, :phone_number

  # validates
  with_options presence: true do
    validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
    validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
    validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
    
    validates :name, presence: true, length: { maximum: 50 }, if: -> { new_record? || changes[:crypted_password] }
    validates :email, presence: true, uniqueness: true, email_format: { message: I18n.t('defaults.email_message') }, if: -> { new_record? || changes[:crypted_password] }
    validates :agreement, acceptance: true, on: :create
    validates :agreement, acceptance: true, on: :update, allow_blank: true

  end
end

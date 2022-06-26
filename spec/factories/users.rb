FactoryBot.define do
  factory :user do
    
  end
end

# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  crypted_password    :string
#  deactivation        :boolean          default(FALSE), not null
#  email               :string           not null
#  enable_notification :boolean          default(FALSE), not null
#  name                :string           not null
#  salt                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

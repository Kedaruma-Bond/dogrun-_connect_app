require 'rails_helper'

RSpec.describe Dog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: dogs
#
#  id            :bigint           not null, primary key
#  birthday      :date
#  breed         :string           default("")
#  castration    :boolean          not null
#  name          :string           not null
#  owner_comment :text             default("")
#  public        :boolean          not null
#  sex           :integer
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

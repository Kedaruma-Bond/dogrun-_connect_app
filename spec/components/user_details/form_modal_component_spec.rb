require 'rails_helper'

RSpec.describe UserDetails::FormModalComponent, type: :component do
  let!(:title) { "title" }
  
  example "正しくレンダリングできること" do
    render_inline(
      UserDetails::FormModalComponent.new(
        title: title
      )
    )
    expect(page).to have_selector("p", text: title)
  end

end

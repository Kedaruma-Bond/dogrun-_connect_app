module ApplicationHelper
  
  def page_title(page_title = '')
    base_title = 'DogrunConnect'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
  
  def render_turbo_stream_flash_messages
    turbo_stream.append "flash", partial: "shared/flash"
  end
  
  def spinner_icon_for_form_disable_button
    image_tag '90-ring-with-bg-white-36.svg', class: "hidden my-auto mr-2 w-6 h-6", data: { "disable-target": "spinner", "disable-confirm-target": "spinner" }
  end
  
  def spinner_icon_for_form_disable_button
    image_tag '90-ring-with-bg-white-36.svg', class: "hidden my-auto mr-2 w-6 h-6", data: { "disable-target": "spinner", "disable-confirm-target": "spinner" }
  end
  
  def inoperable_icon
    image_tag 'inoperable_icon.svg', class: "w-5 h-5 rounded-full text-gray-200 shadow", data: { "disable-selector-target": "icon" }
  end

  def default_meta_tags
    {
      site: Rails.application.credentials.meta_tags[:app],
      charset: 'utf-8',
      description: Rails.application.credentials.meta_tags[:description],
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      og: {
        site_name: Rails.application.credentials.meta_tags[:app],
        description: Rails.application.credentials.meta_tags[:description],
        type: 'website',
        title: Rails.application.credentials.meta_tags[:app],
        url: request.original_url,
        image: image_url('https://res.cloudinary.com/hryerpkcw/image/upload/f_auto,q_auto/v1670480868/anubascj2g0mokzeya6s.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: Rails.application.credentials.meta_tags[:twitter_account],
        title: Rails.application.credentials.meta_tags[:app], 
        descreption: Rails.application.credentials.meta_tags[:description],
      },
      fb: {
        app_id: Rails.application.credentials.meta_tags[:facebook_id]
      }
    }
  end
  
  def togo_inu_shitsuke_hiroba_meta_tags
    {
      site: Rails.application.credentials.meta_tags[:togo_inu_shitsuke_hiroba],
      charset: 'utf-8',
      description: Rails.application.credentials.meta_tags[:description],
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      og: {
        site_name: Rails.application.credentials.meta_tags[:togo_inu_shitsuke_hiroba],
        description: Rails.application.credentials.meta_tags[:description],
        type: 'website',
        title: Rails.application.credentials.meta_tags[:togo_inu_shitsuke_hiroba],
        url: request.original_url,
        image: image_url('https://res.cloudinary.com/hryerpkcw/image/upload/q_auto/hmk6nbsjoqwqjl88yph1.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: Rails.application.credentials.meta_tags[:twitter_account],
        title: Rails.application.credentials.meta_tags[:togo_inu_shitsuke_hiroba], 
        descreption: Rails.application.credentials.meta_tags[:description],
      },
      fb: {
        app_id: Rails.application.credentials.meta_tags[:facebook_id]
      }
    }
  end

  def reon_meta_tags
    {
      site: Rails.application.credentials.meta_tags[:reon],
      charset: 'utf-8',
      description: Rails.application.credentials.meta_tags[:description],
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      og: {
        site_name: Rails.application.credentials.meta_tags[:reon],
        description: Rails.application.credentials.meta_tags[:description],
        type: 'website',
        title: Rails.application.credentials.meta_tags[:reon],
        url: request.original_url,
        image: image_url('https://res.cloudinary.com/hryerpkcw/image/upload/q_auto/powppxfma6fvwetctvtt.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: Rails.application.credentials.meta_tags[:twitter_account],
        title: Rails.application.credentials.meta_tags[:reon], 
        descreption: Rails.application.credentials.meta_tags[:description],
      },
      fb: {
        app_id: Rails.application.credentials.meta_tags[:facebook_id]
      }
    }
  end
  
end

require 'pdf_proxy'

class DonortrustMailer < ActionMailer::Base
  include PDFProxy
  HTTP_HOST = (['staging', 'production'].include?(ENV['RAILS_ENV']) ? 'www.christmasfuture.org' : 'localhost:3000') if !const_defined?('HTTP_HOST')

  #MP - Dec. 14, 2007
  #Added to support US donations
  #When an administrator inputs a deposit on behalf of a user
  #whose original deposit went through GroundSpring, this email
  #is sent so that the user is aware that their deposit has been
  #put into their Christmas Future account.
  def us_deposit_notification(user)
    user_setup_email(user)
    subject "Your donation has been processed."
    body :user => user, :host => HTTP_HOST, :url => dt_login_url(:host => HTTP_HOST)
  end
  
  def user_signup_notification(user)
    user_setup_email(user)
    subject  "The future is here."
    body     :user => user, :url => url_for( :host => HTTP_HOST, :controller => 'dt/accounts', :action => 'activate', :id => user.activation_code )
  end

  def user_change_notification(user)
    user_setup_email(user)
    subject  "#{@subject} ChristmasFuture Account Email Confirmation"
    body :user => user, :host => HTTP_HOST, :url => url_for( :host => HTTP_HOST, :controller => 'dt/accounts', :action => 'activate', :id => user.activation_code )
  end
  
  def user_activation(user)
    user_setup_email(user)
    subject  "#{@subject} Your account has been activated!"
    body :user => user, :host => HTTP_HOST, :url => url_for( :host => HTTP_HOST, :controller => 'dt/accounts', :action => 'show', :id => user.id )
  end

  def user_password_reset(user)
    user_setup_email(user)
    subject  "Your ChristmasFuture password has been reset"
    body :user => user, :host => HTTP_HOST, :url => dt_login_url(:host => HTTP_HOST)
  end

  def account_expiry_reminder(user)
    user_setup_email(user)
    subject  "Your ChristmasFuture account"
    body :user => user, :host => HTTP_HOST, :url => dt_projects_url(:host => HTTP_HOST)
  end
  
  def wishlist_mail(share, project_ids)
    content_type "text/html"
    recipients  share.to_name ? "\"#{share.to_name}\" <#{share.to_email}>" : "#{share.to_email}"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject     'Your friend wanted you to see their ChristmasFuture Wishlist.'
    headers     "Reply-To" => share.name? ? "\"#{share.name}\" <#{share.email}>" : share.email
    url = share.project_id? ? dt_project_path(share.project) : dt_projects_path
    projects = Project.find(project_ids)
    body_data = {:share => share, :host => HTTP_HOST, :url => url, :projects => projects}
    content_type "text/html"
    body render_message('wishlist_mail.text.html.rhtml', body_data)
  end
  
  def invitation_mail(invitation)
    content_type "text/html"
    recipients  invitation.to_name ? "\"#{invitation.to_name}\" <#{invitation.to_email}>" : "#{invitation.to_email}"
    from        invitation.user.full_name.empty? ? invitation.user.email : "#{invitation.user.full_name}<#{invitation.user.email}>"
    sent_on     Time.now
    subject     "You have been invited to join the \"#{invitation.group.name}\" group at ChristmasFuture"
    url = dt_group_url(:host => HTTP_HOST, :id => invitation.group_id)
    body_data = {:invitation => invitation, :host => HTTP_HOST, :url => url}
    content_type "text/html"
    body render_message('invitation_mail.text.html.rhtml', body_data)
  end

  def share_mail(share)
    content_type "text/html"
    recipients  share.to_name ? "\"#{share.to_name}\" <#{share.to_email}>" : "#{share.to_email}"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject     'Your friend thought you would like this.'
    headers     "Reply-To" => share.name? ? "\"#{share.name}\" <#{share.email}>" : share.email
    url = share.project_id? ? dt_project_path(share.project) : dt_projects_path
    body_data = {:share => share, :host => HTTP_HOST, :url => url}
    content_type "text/html"
    body render_message('share_mail.text.html.rhtml', body_data)
  end

  def gift_mail(gift)
    gift_setup_email(gift)
    subject 'You have been gifted!'
    headers "Reply-To" => gift.name? ? "\"#{gift.name}\" <#{gift.email}>" : gift.email
    body_data = {:gift => gift, :host => HTTP_HOST, :url => url_for(:host => HTTP_HOST, :controller => "dt/gifts", :action => "open")}
    content_type "text/html"
    body render_message('gift_mail.text.html.rhtml', body_data)
  end

  def gift_confirm(gift)
    content_type "text/html"
    recipients  "\"#{gift.first_name} #{gift.last_name}\" <#{gift.email}>"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject "Your gift has been created and is ready for opening"
    amount = number_to_currency(gift.amount)
    body "<p>Thanks kind gifter! With your generous gift of #{amount}, we're one gift closer to changing the world...for good. </p><p>Please find your attached gift card</p><p>You can also download your printable ecard here:<br />#{dt_gift_url(:id => gift.id, :host => HTTP_HOST)}.pdf?code=#{gift.pickup_code}</p><p>All the best to you this holiday season,<br />The ChristmasFuture Team</p>"
    attachment "application/pdf" do |a|
      # switched to a proxy pattern (encryption requires a lot of shenanigans)
      proxy = create_pdf_proxy(gift)
      a.body = proxy.render
      a.filename = proxy.filename
    end
  end

  def gift_notify(gift)
    recipients  "\"#{gift.first_name} #{gift.last_name}\" <#{gift.email}>"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject "Your ChristmasFuture gift has been opened"
    content_type "text/html"
    amount = number_to_currency(gift.amount)
    body "<p>The gift you gave to #{gift.to_name} &lt;#{gift.to_email}&gt; has been opened! With your generous gift of #{amount}, we're one gift closer to changing the world...for good. </p><p>All the best to you this holiday season,<br />The ChristmasFuture Team</p>"
  end

  def new_place_notify(place)
    recipients  "The ChristmasFuture Team <info@christmasfuture.org>"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject 	"A new place has been created"
    body 	"The new place #{place.name} was created in the country #{place.country.name}. Please approve or delete it."
  end

 def gift_resendPDF(gift)
    content_type "text/html"
    recipients  "\"#{gift.first_name} #{gift.last_name}\" <#{gift.email}>"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject "Resolved Problem viewing Gift Card"
    body "<p>We have resolved a problem with the ability to view the PDF gift cards that were attached to your gift confirmation.  Please find attached the gift card for your gift to #{ gift.to_name }  </p><p>All the best to you this holiday season,<br />The ChristmasFuture Team</p>"
    attachment "application/pdf" do |a|
      # switched to a proxy pattern (encryption requires a lot of shenanigans)
      proxy = create_pdf_proxy(gift)
      a.body = proxy.render
      a.filename = proxy.filename
    end
  end

  def gift_expiry_notifier(gift)
    recipients  gift.name? ? "\"#{gift.name}\" <#{gift.email}>" : "#{gift.email}"
    from "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on Time.now
    subject 'You gave a ChristmasFuture gift that hasn\'t been opened!'
    headers "Reply-To" => gift.to_name? ? "\"#{gift.to_name}\" <#{gift.to_email}>" : gift.to_email
    body_data = {:gift => gift, :host => HTTP_HOST, :url => url_for(:host => HTTP_HOST, :controller => "dt/gifts", :action => "open")}
    content_type "text/html"
    body render_message('gift_late_notifier.text.html.rhtml', body_data)
  end

  def gift_expiry_reminder(gift)
    gift_setup_email(gift)
    subject 'You have been gifted! This is a reminder'
    headers "Reply-To" => gift.name? ? "\"#{gift.name}\" <#{gift.email}>" : gift.email
    body_data = {:gift => gift, :host => HTTP_HOST, :url => url_for(:host => HTTP_HOST, :controller => "dt/gifts", :action => "open")}
    content_type "text/html"
    body render_message('gift_remind.text.html.rhtml', body_data)
  end

  def tax_receipt(receipt)
    content_type "text/plain"
    recipients  "\"#{receipt.first_name} #{receipt.last_name}\" <#{receipt.email}>"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
    subject "ChristmasFuture Tax Receipt"
    body = <<-TXT
Thank you for making an investment on the ChristmasFuture website. 
The Canadian charitable tax receipt for your investment is attached to this email.
Warmest regards,
The ChristmasFuture team

TXT
    attachment "application/pdf" do |a|
      # switched to a proxy pattern (encryption requires a lot of shenanigans)
      proxy = create_pdf_proxy(receipt)
      a.body = proxy.render(duplicate=false)
      a.filename = proxy.filename
      proxy.post_render # this removes the tmp files needed to encrypt
    end
  end

  # not sure why, but had to add these to avoid gift email rendering problems, seems
  # to be required by the rfacebook_on_rails/view_extensions
  def in_facebook_canvas?
    return false
  end
  def in_mock_ajax?
    return false
  end
  protected
  def user_setup_email(user)
    @subject    = "Welcome to DonorTrust!"
    recipients  user.full_name.empty? ? "#{user.email}" : "\"#{user.full_name}\" <#{user.email}>"
    from        "The ChristmasFuture Team <info@christmasfuture.org>"
    sent_on     Time.now
  end

  def gift_setup_email(gift)
    content_type "text/html"
    recipients  gift.to_name? ? "\"#{gift.to_name}\" <#{gift.to_email}>" : "#{gift.to_email}"
    # from        (gift.name? ? "#{gift.name} " : "") << "<info@christmasfuture.org>"
    from        "\"Christmas Future Team on behalf of " << (gift.name? ? "#{gift.name} " : "") << "\" <#{gift.email}>"
    sent_on     Time.now
  end
end

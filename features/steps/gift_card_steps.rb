Given /I am opening a gift/ do
  @gift = Gift.generate!
  open_gift(@gift.pickup_code)
end

When /I choose any of the gift opening options/ do
  @project = Project.generate!
  visits "/dt/investments/new?project_id=#{@project.id}"
end

When /I go anywhere in the site/ do
  visits "/dt"
end

When /I choose to "(.*)"$/ do |link|
  if link == "let ChristmasFuture figure it out"
    @project = Project.unallocated_project || Project.generate!(:slug => "unallocated")
  elsif link == "Donate it to ChristmasFuture's Operational budget"
    @project = Project.admin_project || Project.generate!(:slug => "admin")
  else
    @project = Project.generate!
  end
  clicks_link(link)
end

When /^I open my gift card again$/ do
  open_gift(@gift.pickup_code)
end

Then /^the gift card amount should be \$([\d]+[\.]?[\d]?)$/ do |amount|
  Gift.find(:last).amount.should == amount.to_f
end

Then /^the gift card balance should be \$([\d]+[\.]?[\d]?)$/ do |balance|
  Gift.find(:last).balance.should == balance.to_f
end

Then /^there should be a cookie with the Gift Card Balance$/ do
  request.cookies["gift_card_balance"].first.should == @gift.balance.to_s
end

Then /there should be a cookie with the Gift Card id/ do
  request.cookies["gift_card_id"].first.should == @gift.id.to_s
end

Then /^I should be told the gift card expiry date$/ do
  response.should have_tag(".notice", "Please note: Your gift card balance will expire on #{@gift.expiry_date.strftime("%b %e, %Y")}. If you need more time, please Deposit the balance into your account.")
end

Then /the gift information should be in the session/ do
  response.session[:gift_card_id].should == @gift.id
  response.session[:gift_card_balance].should == @gift.balance
end

Then /I should see an option to "find a project to donate to"/ do
  response.should have_tag("a[href=/dt/search]", "find a project to donate to")
end

Then /I should see an option to "let CF figure it out"/ do
  response.should have_tag("a[href=/dt/investments/new?]", "let ChristmasFuture figure it out")
end

Then /I should see an option to "Deposit it into my account"/ do
  response.should have_tag("a[href=/dt/accounts/false/deposits/new?deposit%5Bamount%5D=%24#{number_to_currency(@gift.amount).sub(/^\$/, "")}]", "Deposit it into my account")
end

Then /I should see an option to "Donate it to the CF Operations project" PENDING/ do
  response.should have_tag("a[href=/dt/investments/new]", "Donate it to the ChristmasFuture Operational Funds project")
end

Then /I should see an option to "Do nothing"/ do
  response.should have_tag("li", /^Do nothing/)
end

Then /^I should see my gift card balance$/ do
  @gift.reload
  response.should have_tag("div.notice", "Your Gift Card Balance is: #{number_to_currency(@gift.balance)}")
end

Then /^I should see my gift card balance in the top right corner$/ do
  @gift.reload
  response.should have_tag("#giftcard-balance", "Gift Card Balance: #{number_to_currency(@gift.balance)}")
end

Then /^I should be shown my directed order$/ do
  @order = Order.find_by_order_number(request.parameters[:order_number])
  response.should_not have_tag('h2', "Tax Receipt")
  response.should_not have_tag('h2', "Gift(s)")
  response.should have_tag("p", "You just gave #{number_to_currency(@order.total)} to #{@project.name}! Thank you.")
end
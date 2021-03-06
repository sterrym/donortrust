require File.dirname(__FILE__) + '/../spec_helper'

describe Gift do
  before do
    @gift = Factory(:gift)
  end

  describe "Sector Gift" do
    before do
      @sector = Factory(:sector)
      @project = Factory(:project)
      @project.sectors << @sector
      @project.save!
    end

    it "should select a random project from a sector and set project_id if sector id is given" do
      gift = Factory.build(:gift)
      gift.project_id = nil
      gift.sector_id = @sector.id
      gift.save
      gift.project_id.should == @project.id
    end
  end

  it "should create a gift" do
    lambda{ Factory(:gift) }.should change(Gift, :count).by(1)
  end

  describe "validations" do
    it "should belong_to user" do
      @gift.should belong_to(:user)
    end
    it "should belong_to project" do
      @gift.should belong_to(:project)
    end
    it "should belong_to e_card" do
      @gift.should belong_to(:e_card)
    end
    it "should belong_to order" do
      @gift.should belong_to(:order)
    end
    it "should have_one deposit" do
      @gift.should have_one(:deposit)
    end
    it "should validate_presence_of amount" do
      @gift.should validate_presence_of(:amount)
    end
    it "should validate_presence_of email" do
      @gift.should validate_presence_of(:email)
    end
    it "should validate_presence_of to_email" do
      @gift.should validate_presence_of(:to_email)
    end
    # it "should validate_numericality_of amount" do
    #   @gift.should validate_numericality_of(:amount)
    # end
  end
  describe "amount" do
    it "should be numerical" do
      @gift.amount = "hi"
      @gift.valid?
      @gift.errors.on(:amount).should_not be_nil
    end
    it "should be positive" do
      @gift.amount = -1
      @gift.valid?
      @gift.errors.on(:amount).should_not be_nil
    end
    it "should strip a '$' from an amount" do
      @gift.amount = "$100.25"
      @gift.amount.to_s.should == "100.25"
    end
  end

  describe "balance" do
    it "should be the same as the amount" do
      @gift.balance.should == @gift.amount
    end
    it "should be nil if a project is selected" do
      @gift.project = Factory(:project)
      @gift.save
      @gift.balance.should be_nil
    end
    it "should not get changed when getting updated" do
      @gift.balance = 20
      @gift.save
      @gift.balance.should == 20
    end
  end

  describe "send_at" do
    it "should allow future dates on creation" do
      @gift = Factory(:gift, :send_at => 1.day.from_now)
      @gift.errors.on(:send_at).should be_nil
    end
    it "should not allow past dates on creation" do
      @gift = Factory.build(:gift, :send_at => Time.now - 1)
      @gift.valid?
      @gift.errors.on(:send_at).should_not be_nil
    end
    it "should allow future dates on update" do
      @gift = Factory(:gift)
      @gift.update_attributes(:send_at => Time.now + 1).should be_true
    end
    it "should allow past dates on update" do
      @gift = Factory(:gift)
      @gift.update_attributes(:send_at => Time.now - 1).should be_true
    end
    it "should update send_at to Time.now + 20 minutes on update even if send_at is invalid" do
      now = Time.now
      Time.stub!(:now).and_return(now)
      @gift = Factory(:gift)
      @gift.update_attributes(:send_at => Time.now - 1.day, :send_email => 'now').should be_true
      @gift.send_at.should == now + 20.minutes
    end
  end

  describe "send_email set to 'now'" do
    it "should set send_email? to true" do
      @gift.send_email = "now"
      @gift.send_email?.should be_true
    end
    it "should set send_at to Time.now + 20.minutes" do
      now = Time.now
      Time.stub!(:now).and_return(now)
      @gift.send_email = "now"
      @gift.send_at = 2.days.from_now
      @gift.save
      @gift.send_at.should == now + 20.minutes
    end
  end

  describe "sendable scope" do
    it "should return unsent gifts with send_email = 'now'" do
      @gift.send_email = 'now'
      @gift.save!
      Gift.sendable.first.should == @gift
    end
    it "should return unsent gifts with send_email = 'yes'" do
      @gift.send_email = 'yes'
      @gift.save!
      @gift.send_at = 5.days.ago
      @gift.save!
      Gift.sendable.first.should == @gift
    end
    it "should return unsent gifts with send_email = '1' (old true values)" do
      @gift.send_email = '1'
      @gift.save!
      @gift.send_at = 5.days.ago
      @gift.save!
      Gift.sendable.first.should == @gift
    end
    it "should not return unsent gifts with send_email = 'no'" do
      @gift.send_email = 'no'
      @gift.save!
      @gift.send_at = 5.days.ago
      @gift.save!
      Gift.sendable.first.should_not == @gift
    end
    it "should not return unsent gifts with send_email = '0' (old false values)" do
      @gift.send_email = '0'
      @gift.save!
      @gift.send_at = 5.days.ago
      @gift.save!
      Gift.sendable.first.should_not == @gift
    end
    it "should not return unsent gifts with send_at in the future" do
      @gift.send_at = 5.days.from_now
      @gift.save!
      Gift.sendable.first.should_not == @gift
    end
    it "should not return sent gifts" do
      @gift.sent_at = 1.days.ago
      @gift.save!
      Gift.sendable.first.should_not == @gift
    end
  end

  describe "find_unopened_gifts" do
    it "should only find gifts with a pickup_code and that hasn't been sent" do
      @picked_up = Factory(:gift)
      @picked_up.pickup
      @sent = Factory(:gift)
      @sent.send_gift_mail
      # Gift.find_unopened_gifts.should == [@gift]
      Gift.find_unopened_gifts.each do |gift|
        gift.pickup_code.should_not be_nil
        gift.sent_at.should_not be_nil
      end
    end
  end

  it "should create a pickup_code" do
    @gift.pickup_code.should_not be_nil
  end
  describe "pickup" do
    it "should set pickup_code to nil" do
      @gift.pickup
      @gift.pickup_code.should be_nil
    end
    it "should be picked_up?" do
      @gift.pickup
      @gift.picked_up?.should be_true
    end
    it "should set picked_up_at to Time.now" do
      time = Time.now
      Time.stub!(:now).and_return(time)
      @gift.pickup
      @gift.picked_up_at.should == time
    end
  end

  describe "with a project" do
    before do
      @project = Factory(:project)
      @project.update_attributes(:total_cost => 100)
      @project.stub!(:dollars_raised).and_return(90)
    end
    it "should not allow an amount to be greater than the projects current_need" do
      @gift.project = @project
      @gift.update_attributes(:amount => 10.01)
      @gift.errors.on(:amount).should_not be_nil
    end
    it "should allow an amount to be equal than the projects current_need" do
      @gift.project = @project
      @gift.update_attributes(:amount => 10.00)
      @gift.errors.on(:amount).should be_nil
    end
  end

  describe "gift notifications" do
    before do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      time = Time.now
      Time.stub!(:now).and_return(time)
      @gift.update_attributes(:send_at => time)
    end

    describe "pickup" do
      it "should not notify the giver if notify_giver? is false" do
        @gift.notify_giver = false
        lambda {
          @gift.pickup
        }.should_not change(ActionMailer::Base.deliveries, :size)
      end
      it "should notify the giver if notify_giver? is true" do
        @gift.notify_giver = true
        lambda {
          @gift.pickup
        }.should change(ActionMailer::Base.deliveries, :size)
      end
      it "should send the right email" do
        @gift.notify_giver = true
        @gift.pickup
        mail = ActionMailer::Base.deliveries[0]
        mail.to.include?(@gift.email).should be_true
        mail.subject.should == "Your UEnd: gift has been opened"
      end
    end
  end

  describe "directed gifts" do
    before do
      @project = Factory(:project)
    end

    it "should create POIs" do
      lambda do
        Gift.create! :amount => 1, :to_email => "destination@email.com", :to_name => "Receiver Name",
          :email => "sender@email.com", :name => "Sender Name", :project => @project
      end.should change(ProjectPoi, :count).by(2)
    end

    it "should reuse gifts by email" do
      @gift = Factory(:gift, :project => @project)
      lambda do
        # make a gift with identical sender and receiver, and set a user as well
        Gift.create! :amount => 1, :to_email => @gift.to_email, :to_name => @gift.to_name,
          :email => @gift.email, :name => @gift.name, :project => @project
      end.should change(ProjectPoi, :count).by(0)
    end

    it "should capture user" do
      @gift = Factory(:gift, :project => @project)
      # make a gift with identical sender and receiver, and set a user as well
      @user = Factory(:user)
      Gift.create! :amount => 1, :to_email => @gift.to_email, :to_name => @gift.to_name,
        :email => @gift.email, :name => @gift.name, :project => @project, :user => @user
      ProjectPoi.find_by_email(@gift.email).user.should == @user
    end
  end

  describe "non-directed gifts" do
    before do
      @project = Factory(:project)
    end

    it "should not create POIs" do
      lambda do
        Gift.create! :amount => 1, :to_email => "destination@email.com", :to_name => "Receiver Name",
          :email => "sender@email.com", :name => "Sender Name"
      end.should change(ProjectPoi, :count).by(0)
    end
  end
end

#context "Gift Notification" do
#  specify "send_gift_mail? should be false if send_at is not nil" do
#  specify "send_gift_mail? should be true if send_at is nil" do
#  specify "send_gift_mail should set sent_at to not be nil" do
#  specify "send_gift_mail should create an email" do
#end

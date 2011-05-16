require File.dirname(__FILE__) + '/../../spec_helper'

describe Dt::DepositsController do
  it "should use DtApplicationController" do
    controller.should be_kind_of(DtApplicationController)
  end
  
  %w( index show destroy ).each do |m|
    it "should not respond_to the #{m} method" do
      controller.should_not respond_to(m)
    end
  end

  %w( new create edit update ).each do |m|
    it "should respond_to the #{m} method" do
      controller.should respond_to(m)
    end
  end
  
  before do
    @user = mock_model(User)
    controller.stub!(:current_user).and_return(@user)
    controller.stub!(:logged_in?).and_return(true)
    
    @deposit = Factory.build(:deposit)
    @cart = Factory(:cart)
    Cart.stub!(:create).and_return(@cart)
    Cart.stub!(:find).and_return(@cart)
  end

  describe "new action" do
    before do
      @user.stub!(:in_country?).and_return(true)
    end
    
    it "should use the new template" do
      do_request
      pp 
      response.should render_template("new")
    end
    
    it "should require login" do
      controller.should_receive(:logged_in?).and_return(false)
      do_request
      response.should redirect_to(dt_login_path)
    end
    
    it "should load the session[:deposit_params] into params[:deposit]" do
      controller.should_receive(:session).any_number_of_times.and_return({:deposit_params => {:amount => 100}})
      do_request
      params[:deposit][:amount].should == 100
    end
    
    it "should create a new Deposit" do
      Deposit.should_receive(:new).and_return(@deposit)
      do_request
    end
    
    it "should use the us_receipt_layout if current_user isn't in canada" do
      @user.should_receive(:in_country?).with('canada').and_return(false)
      do_request
      response.layout.should == 'layouts/us_receipt_layout'
    end
    
    def do_request
      get "new", :account_id => @user.id
    end
  end
  
  describe "create action" do
    before do
      @deposit.stub!(:user_ip_addr=).and_return(true)
      @deposit.stub!(:valid?).and_return(true)
      Deposit.stub(:new).and_return(@deposit)
    end
    
    it "should redirect to dt_cart_path" do
      do_request
      response.should redirect_to(dt_cart_path)
    end
    
    it "should require login" do
      controller.should_receive(:logged_in?).and_return(false)
      do_request
      response.should redirect_to(dt_login_path)
    end
    
    describe "valid deposit" do
      before do
        @deposit.should_receive(:valid?).any_number_of_times.and_return(true)
      end
      
      it "should find_cart" do
        Cart.should_receive(:create).and_return(@cart)
        do_request
      end

      it "should @cart.add_item" do
        Deposit.stub(:new).and_return(@deposit)
        @cart.should_receive(:add_item).with(@deposit).and_return([@deposit])
        do_request
      end
      
      it "should set flash[:notice]" do
        do_request
        flash[:notice].should_not be_nil
      end
      
      it "should redirect to dt_cart_path" do
        do_request
        response.should redirect_to(dt_cart_path)
      end
    end

    describe "invalid deposit" do
      before do
        @deposit.stub!(:valid?).and_return(false)
      end
      
      it "should render the new template" do
        do_request
        response.should render_template("new")
      end
    end
    
    def do_request
      post "create", :account_id => @user.id, :deposit => @deposit.attributes.delete_if{|d| d.nil?}
    end
  end

  describe "edit action" do
    before do
      @cart_items = mock()
      @cart_items.stub(:find).and_return(Factory(:cart_line_item, :item => @deposit))
      @cart.stub(:items).and_return(@cart_items)
    end
    
    it "should render the edit template" do
      do_request
      response.should render_template("edit")
    end
    
    it "should load the cart" do
      Cart.should_receive(:create).and_return(@cart)
      do_request
    end
    
    it "should load the item from the cart" do
      @cart.should_receive(:items).twice.and_return(@cart_items)
      do_request
      assigns[:deposit].attributes.should eql(@deposit.attributes)
    end
    
    it "should redirect if the item at id/index isn't the right type of object" do
      items = mock()
      items.should_receive(:find).and_return(Factory(:cart_line_item, :item => Factory.build(:investment)))
      @cart.should_receive(:items).and_return(items)
      do_request
      response.should redirect_to(dt_cart_path)
    end
    
    def do_request
      get 'edit', :account_id => @user, :id => 0
    end
  end

  describe "update action" do
    before do
      @cart.add_item(@deposit)
      @cart_items = @cart.items
      @cart_items.each {|ci| ci.stub(:item).and_return(@deposit) }
      @cart.stub(:items).and_return(@cart_items)
    end
    
    it "should redirect to dt_cart_path" do
      do_request
      response.should redirect_to(dt_cart_path)
    end
    
    it "should load the cart" do
      Cart.should_receive(:create).and_return(@cart)
      do_request
    end
    
    it "should load the item from the cart" do
      @cart.should_receive(:items).twice.and_return(@cart_items)
      do_request
      assigns[:deposit].should == @deposit
    end
    
    it "should update cart" do
      @cart.should_receive(:update_item).with("0", @deposit)
      do_request
    end

    it "should add a \"successful\" notice" do
      do_request
      flash[:notice].should_not be_blank
    end
    
    it "should redirect and not update cart if the item at id/index isn't the right type of object" do
      @cart.should_receive(:items).and_return([ Factory(:cart_line_item, :item => Investment.new) ])
      @cart.should_not_receive(:update_item)
      do_request
      response.should redirect_to(dt_cart_path)
    end
    
    it "should render the edit template if !valid?" do
      @deposit.stub(:valid?).and_return(false)
      do_request
      response.should render_template("edit")
    end

    def do_request
      put 'update', {:controller => 'dt/deposits', :action => :update, :account_id => @user.id, :id => @cart_items.last.id, :deposit => {:amount => 50} }
    end
  end

end

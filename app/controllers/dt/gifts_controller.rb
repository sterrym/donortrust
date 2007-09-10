class Dt::GiftsController < DtApplicationController

  def new
    store_location
    @gift = Gift.new
    if logged_in?
      user = User.find(current_user.id)
      %w( email first_name last_name address city province postal_code country ).each {|f| @gift[f.to_sym] = current_user[f.to_sym] }
      @gift[:name] = current_user.full_name if logged_in?
      @gift[:email] = current_user.email
    end
  end

  def create
    store_location
    @gift = Gift.new( gift_params )
    respond_to do |format|
      if @gift.save
        format.html
      else
        format.html { render :action => "new" }
      end
    end
  end

  def confirm
    store_location
    @gift = Gift.new( gift_params )
    respond_to do |format|
      if @gift.valid?
        format.html { render :action => "confirm" }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def open
  end

  protected
  def gift_params
    card_exp = "#{params[:gift][:expiry_month]}/#{params[:gift][:expiry_year]}" if params[:gift][:expiry_month] != nil && params[:gift][:expiry_year] != nil
    gift_params = params[:gift]
    gift_params.delete :expiry_month
    gift_params.delete :expiry_year
    gift_params[:card_expiry] = card_exp if gift_params[:card_expiry] == nil
    gift_params[:user_id] = current_user.id if logged_in?
    gift_params
  end

  def iats_process( record )
    require 'iats/iats_link'
    iats = IatsLink.new
    iats.test_mode = @test_mode
    iats.agent_code = '2CFK99'
    iats.password = 'K56487'
    # When taking CDN$, can we only have cardholder_name or will it work with the US$ info?
    # if it would work, just use it all the time...
    #iats.cardholder_name = "#{current_user.first_name} #{current_user.last_name}"
    # When taking US$, you must remove cardholder_name and add the following before calling process_credit_card:
    iats.first_name = record[:first_name]
    iats.last_name = record[:last_name]
    iats.street_address = record[:address]
    iats.city = record[:city]
    iats.state = record[:province]
    iats.zip_code = record[:postal_code]

    iats.card_number = record[:credit_card]
    iats.card_expiry = record[:card_expiry]
    iats.dollar_amount = record[:amount]
    
    if ENV["RAILS_ENV"] == 'test'
      iats.status = 1
      iats.authorization_result = 1234
    else
      iats.process_credit_card
    end
    iats
  end
end

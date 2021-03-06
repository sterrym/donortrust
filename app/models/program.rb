require 'acts_as_paranoid_versioned'
class Program < ActiveRecord::Base
  acts_as_paranoid_versioned
  
  has_many :projects, :dependent => :destroy
  belongs_to :contact
  belongs_to :rss_feed

  validates_presence_of :name
  validates_uniqueness_of :name

  validate do |me|
    # In each of the 'unless' conditions, true means that the association is reloaded,
    # if it does not exist, nil is returned
    unless me.contact( true )
      me.errors.add :contact_id, 'does not exist'
    end
  end

  def projects_count
    return projects.count
  end

  def self.total_programs
    return self.find(:all).size
  end
  
  def self.get_programs
    return self.find(:all)   
  end
  
  def get_total_costs
    @get_total_costs ||= self.projects.inject(0) {|sum, p| sum += BigDecimal.new(p.total_cost.to_s) }
  end
  
  def get_total_raised
    @get_total_raised ||= self.projects.all(:include => :investments).inject(0){|sum, p| sum += BigDecimal.new(p.dollars_raised.to_s) }
  end
  
  def get_total_days_remaining
    projects = Project.find(:all, :conditions => "program_id = " + id.to_s)    
    total_days = 0
    total_undefined = false
    projects.each do |project|
      project_days = project.days_remaining
      if project_days == nil then
        total_undefined = true
      else
        total_days += project_days
      end
    end
    if total_undefined then
      total_days = "undefined"
    end
    total_days = 0 if total_days < 0
    return total_days
  end
  
  def days_until_last_project_ends 
    projects = Project.find(:all, :conditions => "program_id = " + id.to_s)  
    days_remaining = 0
    if projects.size > 0
      last_project = projects[0]
      projects.each do |project|
        last_project = project if project.days_remaining > last_project.days_remaining
      end
      days_remaining = last_project.days_remaining
    end
    return days_remaining
  end
  
  def get_percent_raised
    percent_raised = 0
    total_cost = get_total_costs
    if total_cost > 0 
      percent_raised = (get_total_raised * 100 / total_cost).floor
      if percent_raised > 100 then percent_raised = 100 end
    end    
    return percent_raised
  end
  
end

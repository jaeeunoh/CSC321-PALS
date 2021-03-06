class User < ApplicationRecord
  require 'csv'
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
        # :confirmable
        
  enum gender: [:male, :female, :other, :prefer_not_to_disclose]
  enum contact_method: [:phone, :email]
         
  attr_accessor :other_interests
  validates :email, uniqueness: true, allow_nil: true
  validates :name, uniqueness: true
  validates :name, presence: true
  validates :other_gender, presence: true, if: Proc.new {|u| u.other?}
  validates :city, format: { with: /\A[a-zA-Z]+\z/ }, allow_blank: true
  validates :state, format: { with: /\A[a-zA-Z]{2}\z/ }, allow_blank: true
  
  validate :different_home_work_phone, :home_or_work_phone
  
  def different_home_work_phone
    errors.add(:home_phone) if home_phone == work_phone
  end
  
  def home_or_work_phone
    errors.add(:home_phone) if home_phone.blank? and work_phone.blank?
  end
  
  has_attached_file :avatar, styles: { medium: "180x180>", thumb: "50x50>" }, default_url: "/assets/blank-avatar.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  has_and_belongs_to_many :interests
  belongs_to :organization, optional: true
  
  has_many :donations
  has_many :shifts
  
  def self_import(file)
    CSV.foreach(file.path, headers: true) do |row|
      User.create! row.to_hash
    end
  end
  
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  def will_save_change_to_email?
    false
  end
end

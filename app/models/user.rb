class User < ActiveRecord::Base
  #validates_presence_of :email
  validates :email, presence: true, email: true, uniqueness: true
  validates :uid, presence: true
  validates :provider, presence: true
  has_many :tokens
  has_many :my_polls

  def self.from_omniauth(data)
    User.where(provider: data[:provider], uid: data[:uid]).first_or_create do |user|
      user.email = data[:info][:email]
    end
  end
end

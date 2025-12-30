class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :class_sessions, through: :reservations

  after_create do
    customer = Stripe::Customer.create(email: self.email)
    update(stripe_id: customer.id)
  end

  def admin?
    admin == true
  end
end

#encoding: utf-8
class User < ActiveRecord::Base
  
  has_many  :reviews,  dependent: :destroy
  has_many  :rooms,    dependent: :destroy

	EMAIL_REGEXP=/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

#mailcatcher

	validates_presence_of :email, :full_name, :location
	validates_length_of :bio, minimum: 30, allow_blank: false
	validates_uniqueness_of :email
	validates_format_of :email, with: EMAIL_REGEXP

  scope :confirmed, -> { where.not(confirmed_at: nil) } 
	
	#utilizado na definição manual de validação.
	#validate :email_format
	
	has_secure_password
	
	before_create do |user|
	  user.confirmation_token = SecureRandom.urlsafe_base64	  
	end
	
	def confirm!
	  return if confirmed?
	  
	  self.confirmed_at = Time.current
	  self.confirmation_token = ''
	  save!
	end
	
	def confirmed?
	  confirmed_at.present?
	end
	
	def self.authenticate(email, password)
	   user = confirmed.find_by(email: email)

	   if user.present?
	     user.authenticate(password)
	   end
	end
	
	private

	#Essa validação pode ser representada da seguinte forma:
	#validates_format_of :email, with: EMAIL_REGEXP
	def email_format
		erros.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
	end
end

require 'active_model'

module SolidusPaypalBraintree
  class Transaction
    include ActiveModel::Model

    attr_accessor :nonce, :payment_method, :payment_type, :address, :email, :phone

    validates :nonce, presence: true
    validates :payment_method, presence: true
    validates :payment_type, presence: true
    # validates :phone, presence: true # We don't have the phone field from paypal response
    validates :email, presence: true

    validate do
      unless payment_method.is_a? SolidusPaypalBraintree::Gateway
        errors.add(:payment_method, 'Must be braintree')
      end
      # TODO: use a configuration option to allow editing the address
      if address && !address.valid? && false
        address.errors.each do |field, error|
          errors.add(:address, "#{field} #{error}")
        end
      end
    end

    def address_attributes=(attributes)
      self.address = TransactionAddress.new attributes
    end
  end
end

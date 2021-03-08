class Order < ActiveRecord::Base
    has_one :drink
    has_one :location
    has_one :client
end
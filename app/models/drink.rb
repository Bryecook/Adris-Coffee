class Drink < ActiveRecord::Base
    has_many :orders
end
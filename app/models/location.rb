class Location < ActiveRecord::Base
    belongs_to :city
    belongs_to :order
end
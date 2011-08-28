class Store < ActiveRecord::Base
  validates_presence_of :name, :address, :latitude, :longitude
end

class Store < ActiveRecord::Base
  validates_presence_of :name, :address, :latitude, :longitude

  def as_json(options = {})
    {
      :name => self.name,
      :address => self.address,
      :latitude => self.latitude,
      :longitude => self.longitude,
      :picture => self.picture
    }
  end
end

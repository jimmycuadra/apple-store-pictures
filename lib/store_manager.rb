require "json"

class StoreManager
  CACHE_PATH = File.expand_path("../../tmp/scrape.json", __FILE__)

  def initialize
    if File.exists?(CACHE_PATH)
      @stores = JSON.parse(File.read(CACHE_PATH))
    else
      @stores = {}
    end
  end

  def scrape
    require "nokogiri"
    require "open-uri"

    print "Fetching store list..."
    doc = Nokogiri::HTML(open("http://www.apple.com/retail/storelist/"))
    doc.css("#usstores a").each { |link| @stores[link.content] = { "url" => link['href'] } if @stores[link.content].nil? }
    puts " done."

    @stores.each do |name, data|
      if data["address"].nil?
        print "Fetching address for #{name}..."
        doc = Nokogiri::HTML(open("http://www.apple.com#{data['url']}"))
        @stores[name]["address"] = doc.css(".adr span").map { |span| span.content }.join(" ")
        puts " done."
      else
        puts "Address for #{name} already known."
      end
    end

    save
  end

  def geocode
    require "rest-client"

    @stores.each do |name, data|
      if @stores[name]["latitude"].nil? || @stores[name]["longitude"].nil?
        print "Geocoding address of #{name}..."
        RestClient.get("http://maps.googleapis.com/maps/api/geocode/json", {
          :params => { :address => data["address"], :sensor => "false" }
        }) do |response|
          response = JSON.parse(response)
          case response["status"]
          when "OK"
            @stores[name].merge!({
              "latitude" => response["results"][0]["geometry"]["location"]["lat"],
              "longitude" => response["results"][0]["geometry"]["location"]["lng"]
            })
            puts " done."
          when "ZERO_RESULTS"
            puts " failed. Removing from list of stores."
            @stores.delete(name)
          else
            raise response["status"]
          end
        end
      else
        puts "Geo information for #{name} already known."
      end
    end

    save
  end

  def create
    @stores.each do |name, data|
      unless Store.where(:name => name).exists?
        print "Creating record for #{name}..."
        Store.create!(:name => name, :address => data["address"], :latitude => data["latitude"], :longitude => data["longitude"])
        puts " done."
      end
    end
  end

  private

  def save
    File.open(CACHE_PATH, "w") { |f| f.write JSON.generate(@stores) }
  end
end

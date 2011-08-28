desc "Scrape the web and create any missing store records"
task :scrape do
  require "json"

  cache_path = File.expand_path("../../../tmp/scrape.json", __FILE__)
  if File.exists?(cache_path)
    stores = JSON.parse(File.read(cache_path))
    puts "Using cached results from #{cache_path}."
    puts stores.inspect
  else
    require "nokogiri"
    require "open-uri"
    require "rest-client"

    stores = {}

    print "Fetching store list..."
    doc = Nokogiri::HTML(open("http://www.apple.com/retail/storelist/"))
    doc.css("#usstores a").each { |link| stores[link.content] = { "url" => link['href'] } }
    puts " done."

    stores.each do |name, data|
      print "Fetching address for #{name}..."
      doc = Nokogiri::HTML(open("http://www.apple.com#{data['url']}"))
      stores[name]["address"] = doc.css(".adr span").map { |span| span.content }.join(" ")
      puts " done."

      print "Geocoding address of #{name}..."
      RestClient.get("http://maps.googleapis.com/maps/api/geocode/json", {
        :params => { :address => data["address"], :sensor => "false" }
      }) do |response|
        response = JSON.parse(response)
        case response["status"]
        when "OK"
          stores[name].merge!({
            "latitude" => response["results"][0]["geometry"]["location"]["lat"],
            "longitude" => response["results"][0]["geometry"]["location"]["lng"]
          })
          puts " done."
        when "ZERO_RESULTS"
          puts " failed. Removing from list of stores."
          stores.delete(name)
        else
          raise response["status"]
        end
      end
    end

    File.open(cache_path, "w") { |f| f.write(JSON.generate(stores)) }
    puts "Results cached to file: #{cache_path}."
  end
end

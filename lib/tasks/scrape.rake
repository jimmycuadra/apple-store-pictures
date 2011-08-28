require "store_manager"

namespace :stores do
  desc "Scrape apple.com for stores"
  task :scrape do
    StoreManager.new.scrape
  end

  desc "Use Google to get lat/longs for each store"
  task :geocode do
    StoreManager.new.geocode
  end

  desc "Create records for missing stores"
  task :create do
    StoreManager.new.create
  end
end

desc "Run all store tasks to fill in missing stores"
task :stores => ["stores:scrape", "stores:geocode", "stores:create"]

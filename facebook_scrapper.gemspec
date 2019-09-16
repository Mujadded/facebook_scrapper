require File.expand_path("../lib/facebook_scrapper/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "facebook_scrapper"
  s.version = FacebookScrapper::VERSION
  s.date = "2019-09-14"
  s.summary = "scrap data from fb without api"
  s.description = "This is a facebook scrapper bot that dosent require api to scrap facebook data"
  s.authors = ["Mujadded Al Rabbani Alif"]
  s.email = "mujadded.alif@gmail.com"
  s.files = Dir.glob("{lib}/**/*")
  s.homepage =
    "https://github.com/Mujadded/facebook_scrapper"
  s.license = "MIT"
end

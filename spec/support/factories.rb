TEXTS = %w(adweek aeon-magazine andreessen-horowitz animal ars-technica avc bbc brain-pickings
           coding-horror creative-applications fast-company fivethirtyeight forbes gigaom yahoo-tech
           google-analytics-blog google-ventures-library hacker-news ideo-labs medium wired quartz
           mit-technology-review mlwave nasa new-statesman new-york-times nieman-journalism-lab
           official-google-blog pandodaily platform-thinking plausible-thought project-syndicate
           schneier-on-security scientific-american subtractioncom the-atlantic the-economist
           the-guardian the-media-briefing the-new-yorker the-next-web the-verge time vice way-out)

class Document; end

FactoryGirl.define do
  factory :credentials do
    key SecureRandom.hex
    password_protected false
  end
end

require 'nokogiri'
require 'capybara'

Capybara.app_host = 'https://www.google.com'
Capybara.run_server = false

g = Capybara::Session.new(:selenium)
g.visit('/')
g.click_link_or_button('Sign in')
g.fill_in('Email', :with => ARGV.shift)
g.fill_in('Passwd', :with => ARGV.shift)
g.click_link_or_button('Sign in')

# Have to organize the stupid bookmarks file format into HTML
template = %Q{
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
</head>
<body>
%s
</body>
</html>
}

# Fix up the links
# sort_by { rand } so if there is a weird bookmark,
# we can still get everything in there by running it a few times
links = File.readlines(ARGV.shift).map do |line|
  line.match(/(<A .*<\/A>)/)[1] rescue nil
end.compact.sort_by { rand }.join("\n")

doc = Nokogiri::HTML(template % links)

doc.search('a').each do |a|
  g.visit('/bookmarks/mark?op=add&output=popup')
  g.fill_in('title', :with => a.text)
  g.fill_in('bkmk', :with => a[:href])
  g.fill_in('labels', :with => a[:tags])
  g.click_link_or_button('Add bookmark')
end



require 'net/http'
require 'uri'
require 'cgi'

text = "<html><head><title>Delicious2Google</title></head><body>" +
  "<h1>Upload</h1>" +
  "<form action='https://www.google.com/bookmarks/mark?op=upload&zx=#{rand(65535)}' method='POST'>" +
  "<input type='submit'/><input type='hidden' id='data'></form>" +
  "<textarea id='xml' style='display:none'>\n<bookmarks>"

File.open(ARGV[0], "r").each_line do |line|
  match = line.match(/<DT><A HREF="(.*)" ADD_DATE="(.*)" PRIVATE="(.*)" TAGS="(.*)">(.*)<\/A>/)

  if match
    link = CGI::escapeHTML(match[1].split("?")[0].split("#")[0])
    date = CGI::escapeHTML(match[2])
    tags = match[4].split(",").map! do |t| CGI::escapeHTML(t) end
    title = CGI::escapeHTML(match[5])

    text += "<bookmark><url>#{link}</url><title>#{title}</title>" +
      "<labels><label>#{tags.join(",")}</label></labels></bookmark>"
  end
end

text += "</bookmarks>\n</textarea>"
text += <<eos
<script type='text/javascript'>
var src = document.getElementById('xml');
var tgt = document.getElementById('data');
tgt.name = "<?xml version";
tgt.value = '"1.0" encoding="utf-8"?>' + src.value;
</script>
eos
text += "</body><html>"

File.new(ARGV[1], "w").puts text

require 'open-uri'
require 'nokogiri'

url = 'https://grand_order.wicurio.com/index.php?'
param = '%E3%83%9E%E3%82%B7%E3%83%A5%E3%83%BB%E3%82%AD%E3%83%AA%E3%82%A8%E3%83%A9%E3%82%A4%E3%83%88'

charset = nil
html = open(url + param) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトル
p doc.title

body = doc.css("body")

p "h3"
h = body.css("h3")
h.each{|ele|
  p ele.inner_text
}
p ""
p "h2"
h = body.css("h2")
h.each{|ele|
  p ele.inner_text
}
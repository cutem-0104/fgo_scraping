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

body = doc.css("#body > div > table")[0]

tr = body.css('tr')
tr.each{|ele|
  key = ele.css("th").inner_text
  value = ele.css("td").inner_text
  p key + " : " + value
}
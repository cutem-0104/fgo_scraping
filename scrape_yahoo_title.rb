# http://d.hatena.ne.jp/otn/20090509/p1

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
url = 'https://grand_order.wicurio.com/index.php?%E3%82%B5%E3%83%BC%E3%83%B4%E3%82%A1%E3%83%B3%E3%83%88%E4%B8%80%E8%A6%A7'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得c
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトルを表示
p doc.title

table = doc.css(".style_table > tbody > tr")
p table[2]

p "servant"
table.each{|s|
  ele = s.css("th")[0]
  if (!ele.nil?) then
    p ele.inner_text
  end
}
require "kindle_highlights"

require "kh2anywhere/version"

module Kh2anywhere
  # Your code goes here...
end

puts "START kindle highlights output to markdown"
kindle = KindleHighlights::Client.new(email_address: ENV['KINDLE_EMAIL'], password: ENV['KINDLE_PASSWD'], root_url: 'https://read.amazon.co.jp')

kindle.books.each_with_index do |book, i|
  puts "========== TITLE: #{book.title}"
  hs = kindle.highlights_for(book.asin)
  puts "highlight count: #{hs.size}"

  path = "mds/#{book.title}.md"
  File.delete(path) if File.exists?(path)

  File.open(path, "a") do |f|
    f.puts("# kindleハイライト #{book.title}")
    f.puts("")

    hs.each do |h|
      f.puts("* #{h.location}: #{h.text}")
    end

    f.puts("")
    f.puts("")
  end
end

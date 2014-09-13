
# -*- encoding : utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'nori'

module Xmfun
  module Util
    class PictureFinder
      def self.find_picture(mp3_file)
        title  = nil
        artist = nil

        Mp3Info.open("mp3_file") do |mp3|
          title  = mp3.tag.title.nil?? mp3_file.filename : mp3.tag.title
          artist = mp3.tag.artist.nil?? "" : mp3.tag.artist
        end

        url = "http://www.xiami.com/search?key=#{title}"
        tracks = Nokogiri::HTML(open(url, "Client-IP" => "220.181.111.168"))

        tr = tracks.css(".track_list tr").detect do |n|
          n.css("td[class='song_artist']").text.strip == artist &&
            n.css("td[class='song_name'] a").first.text == title
        end

        link = tr.css("td[class='song_name'] a").first['href']

      end
    end
  end
end

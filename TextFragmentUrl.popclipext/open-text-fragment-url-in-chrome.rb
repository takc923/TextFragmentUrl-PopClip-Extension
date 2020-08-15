require 'uri'

def encode(str)
  URI.encode(str).gsub('-', '%2D').gsub(',', '%2C').gsub('&', '%26')
end

raw_text = ENV["POPCLIP_TEXT"]
paragraphs = raw_text.split(/\n+/).map { |t| encode(t) }

text_fragment_keyword = ":~:text="
start_text = "#{paragraphs[0]}"
end_text = if paragraphs.length > 1
             ",#{paragraphs[-1]}"
           else
             ''
           end

current_directory = File.expand_path(File.dirname(__FILE__))
url = %x("#{current_directory}/get-current-url-on-chrome.scpt")
          .chomp # The output includes a new line.
          .sub(/#{text_fragment_keyword}.*$/, '') # Remove text fragment on the current URL.
hash = if url.include?('#')
         ''
       else
         '#'
       end
text_fragment_url = url + hash + text_fragment_keyword + start_text + end_text
IO.popen('pbcopy', 'w') { |f| f << text_fragment_url }
system('open', '-b', 'com.google.Chrome', text_fragment_url)

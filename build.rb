require 'kramdown'
require 'fileutils'

def convert_wiki_links(text)
  text.gsub(/\[\[([^\]]+)\]\]/, '[\1](/wiki/\1/)')
end

def build
  Dir.glob('data/wiki/**/*.md').each do |file_path|
    content = File.read(file_path, encoding: 'UTF-8')
    
    converted_content = convert_wiki_links(content)
    html_body = Kramdown::Document.new(converted_content).to_html
    
    full_html = <<~HTML
      <!DOCTYPE html>
      <html lang="ko">
      <head>
          <meta charset="UTF-8">
          <title>Personal Wiki</title>
      </head>
      <body>
      #{html_body}
      </body>
      </html>
    HTML

    doc_name = File.basename(file_path, '.md')
    out_dir = doc_name == 'index' ? '.' : File.join('wiki', doc_name)
    
    FileUtils.mkdir_p(out_dir)
    File.write(File.join(out_dir, 'index.html'), full_html, encoding: 'UTF-8')
  end
end

build
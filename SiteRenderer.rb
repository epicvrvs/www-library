require 'www-library/ScriptEntry'
require 'www-library/HTMLWriter'

module WWWLib
	class SiteRenderer
		Doctype = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'
		W3URL = 'http://www.w3.org/1999/xhtml'
		HTMLType = 'text/html'
		CSSType = 'text/css'
		Charset = 'UTF-8'
		Language = 'en'
		
		def initialize
			@stylesheets = []
			@scripts = []
			@inlineStylesheets = []
		end
		
		def addStylesheet(stylesheet)
			@stylesheets << stylesheet
		end
		
		def addScript(source, type = 'text/javascript')
			@scripts << ScriptEntry.new(type, source)
		end
		
		def addInlineStylesheet(code)
			@inlineStylesheets << code
		end
		
		def get(title, content, additionalHead = nil)
			output = "#{Doctype}\n"
			writer = HTMLWriter.new(output)
			writer.html('xmlns' => W3URL, 'xml:lang' => Language) do
				writer.head do
					writer.meta('http-equiv' => 'Content-Type', 'content' => "#{HTMLType}; charset=#{Charset}")
					
					@stylesheets.each do |stylesheet|
						writer.link(rel: 'stylesheet', type: CSSType, media: 'screen', href: stylesheet)
					end
					
					@inlineStylesheets.each do |stylesheet|
						writer.style(type: CSSType, media: 'screen') do
							writer.cdata { stylesheet }
						end
					end
					
					writer.title { title }
					
					if additionalHead != nil
						write additionalHead
					end
				end
				writer.body do
					content
				end
			end
			return writer.output
		end
	end
end

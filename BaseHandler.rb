require 'www-library/HTMLWriter'
require 'www-library/RequestManager'

module WWWLibrary
  class SiteContainer
    extend GetWriter

    def initialize(site)
      @site = site
      @generator = site.generator
      installHandlers
    end

    def addHandler(handler)
      @site.mainHandler.add(handler)
    end

    def raiseError(error, request)
      raise WWWLib::RequestManager::Exception.new(@generator.get(error, request))
    end
  end
end

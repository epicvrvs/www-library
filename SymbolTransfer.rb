require 'www-library/HTML'

module WWWLib
  class SymbolTransfer
    def getMemberSymbol(symbol)
      return ('@' + symbol.to_s).to_sym
    end

    def translateSymbolName(name)
      output = ''
      isUpper = false
      name.to_s.each_char do |char|
        if char == '_'
          isUpper = true
          next
        end

        if isUpper
          char = char.upcase
          isUpper = false
        end

        output += char
      end
      return output.to_sym
    end

    def transferSymbols(input, hash = {}, entityExceptions = [])
      input.each do |symbol, value|
        translatedSymbol = hash[symbol] || symbol
        translatedSymbol = translateSymbolName translatedSymbol
        memberSymbol = getMemberSymbol translatedSymbol
        case value
        when String
          if !(entityExceptions.include?(symbol) || entityExceptions.include?(translatedSymbol))
            value = HTMLEntities::encode(value)
          end
        when Time
          offset = value.utc_offset
          value.utc
          value += offset
        end
        instance_variable_set(memberSymbol, value)

        self.class.send(:define_method, translatedSymbol) do
          return instance_variable_get(memberSymbol)
        end

        operatorSymbol = (translatedSymbol.to_s + '=').to_sym
        self.class.send(:define_method, operatorSymbol) do |value|
          instance_variable_set(memberSymbol, value)
        end
      end
    end
  end
end

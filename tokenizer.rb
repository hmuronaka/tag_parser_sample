require 'stringio'

class Tokenizer

  def initialize(text)
    @text = StringIO.new(text, "r+")
    @history = []
  end

  def get_token()
    return @history.pop if not @history.empty?

    skip_ws
    while not @text.eof?
      ch = @text.getc
      case ch
      when "\""
        return :word, get_word()
      when "*", "+", "(", ")"
        return :symbol, get_symbol(ch)
      end
    end
  end

  def unget_token(type, token)
    @history << [type, token]
  end

  def eof?
    @text.eof?
  end

  private

  def skip_ws()
    while not @text.eof?
      ch = @text.getc
      if ch !~ /^\s*$/
        @text.ungetc ch
        break
      end
    end
  end 
  def get_word()
    word = ""
    is_escape = false
    while true
      raise "EOFError" if @text.eof
      ch = @text.getc

      if ch == "\\" and not is_escape
        is_escape = true
      elsif ch == "\"" and not is_escape
        break
      else
        word << ch
        is_escape = false
      end
    end
    word
  end

  def get_symbol(ch)
    ch
  end

end

t = Tokenizer.new("\"a b\"   \"c \\\"d\" ")

while not t.eof?
  puts t.get_token
end

require './tokenizer'
class Parser

  def initialize(text)
    @t = Tokenizer.new(text)
  end

  def parse()
    i = 1
    while not @t.eof?
      puts "#{i} #{expr()}"
      i += 1
    end
  end

  private
  def expr
    or_expr
  end

  def or_expr(left_value = nil)
    value = left_value || and_expr() 
    type, token = @t.get_token

    if type == :symbol and token == '+'
      return or_expr(or_exec(value, and_expr))
    else
      @t.unget_token(type, token)
      return value
    end
  end

  def and_expr(left_value = nil)
    value = left_value || primitive_expr()

    type, token = @t.get_token

    if type == :symbol and token == '*'
      return and_expr(and_exec(
         value, 
         primitive_expr))
    else
      @t.unget_token(type, token)
      return value
    end
  end

  def primitive_expr
    type, token = @t.get_token
    if type == :word
      puts token
      return token
    elsif type == :symbol && token == '('
      result = expr()
      type, token = @t.get_token
      raise "Error" if not (type == :symbol && token == ')')
      return result
    end
  end


  def or_exec(left, right)
    msg = "(+ #{left} #{right})"
    #puts msg
    msg
  end

  def and_exec(left, right)
    msg = "(* #{left} #{right})"
    #puts msg
    msg
  end

end

p = Parser.new("\"tag1\" + \"tag2\" * \"tag3\" + \"tag4\"")
p.parse()

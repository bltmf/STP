def to_rpn(expression)
    output = []
    operators = []
    precedence = { '+' => 1, '-' => 1, '*' => 2, '/' => 2 }
    
    expression.scan(/\d+|\+|\-|\*|\//).each do |token|
      if token =~ /\d+/
        output << token
      elsif token =~ /\+|\-|\*|\//
        while !operators.empty? && precedence[operators.last] >= precedence[token]
          output << operators.pop
        end
        operators << token
      end
    end
  
    output.concat(operators.reverse)
    output.join(' ')
  end
  
  input = "4 + 5 * 9 - 3 / 6"
  puts to_rpn(input)
  
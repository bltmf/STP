def to_rpn(expression)
  output = []
  operators = []
  precedence = { '+' => 1, '-' => 1, '*' => 2, '/' => 2, '^' => 3 }
  right_associative = ['^']

  tokens = expression.scan(/-?\d+|\+|\-|\*|\/|\^|\(|\)/)

  tokens.each_with_index do |token, index|
    if token =~ /^-?\d+$/
      output << token
    elsif token =~ /\+|\-|\*|\/|\^/
      while !operators.empty? &&
            precedence[operators.last] &&
            ((right_associative.include?(token) && precedence[operators.last] > precedence[token]) ||
             (!right_associative.include?(token) && precedence[operators.last] >= precedence[token]))
        output << operators.pop
      end
      operators << token
    elsif token == '('
      operators << token
    elsif token == ')'
      while !operators.empty? && operators.last != '('
        output << operators.pop
      end
      operators.pop
    end
  end

  output.concat(operators.reverse)
  output.join(' ')
end

  input = "3-5+"
  puts "Input: #{input}"
  puts "RPN: #{to_rpn(input)}"

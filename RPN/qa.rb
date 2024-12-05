require 'minitest/autorun'

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

class TestToRpn < Minitest::Test
  def test_simple_expression
    assert_equal "2 3 +", to_rpn("2 + 3")
  end

  def test_expression_with_multiplication
    assert_equal "2 3 4 * +", to_rpn("2 + 3 * 4")
  end

  def test_expression_with_division
    assert_equal "10 2 / 5 +", to_rpn("10 / 2 + 5")
  end

  def test_expression_with_negative_numbers
    assert_equal "-3 4 +", to_rpn("-3 + 4")
    assert_equal "4 -2 +", to_rpn("4 + -2")
  end

  def test_complex_expression
    assert_equal "4 5 9 * + 3 6 / -", to_rpn("4 + 5 * 9 - 3 / 6")
  end

  def test_expression_with_all_operations
    assert_equal "3 4 2 * 1 5 - 2 3 ^ ^ / +", to_rpn("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")
  end

  def test_nested_expressions
    assert_equal "1 2 + 3 4 + *", to_rpn("(1 + 2) * (3 + 4)")
  end
end

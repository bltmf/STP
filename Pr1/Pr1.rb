# Массив возможных выборов
choices = ["rock", "scissors", "paper"]

# Метод для определения победителя
def determine_winner(player_choice, computer_choice)
  if player_choice == computer_choice
    "Draw!"
  elsif (player_choice == "rock" && computer_choice == "scissors") ||
        (player_choice == "scissors" && computer_choice == "paper") ||
        (player_choice == "paper" && computer_choice == "rock")
    "You win!"
  else
    "Сomputer won!"
  end
end

# Главная логика игры
loop do
  puts "Enter your choice: rock, scissors or paper (or 'exit' to end):"
  player_choice = gets.chomp.downcase

  break if player_choice == "exit"

  if choices.include?(player_choice)
    computer_choice = choices.sample
    puts "Computer won: #{computer_choice}"

    result = determine_winner(player_choice, computer_choice)
    puts result
  else
    puts "Incorrect input. Try again."
  end
end

puts "Thanks for playing!"

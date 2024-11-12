def average(array)
    return 0 if array.empty?  # Перевіряємо, чи масив не порожній
  
    sum = array.sum           # Сума елементів масиву
    count = array.size        # Кількість елементів у масиві
  
    sum.to_f / count          # Ділимо суму на кількість і повертаємо середнє
  end  
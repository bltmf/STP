class ShoppingCart
    def initialize
      @items = []  # Масив для зберігання товарів у кошику
    end
  
    # Метод для додавання товару до кошика
    def add_item(name, price, quantity = 1)
      item = { name: name, price: price, quantity: quantity }
      @items << item
    end
  
    # Метод для обчислення загальної вартості
    def total_price
      total = 0
      @items.each do |item|
        total += item[:price] * item[:quantity]  # Ціна помножена на кількість
      end
      total
    end
  
    # Метод для виведення списку товарів
    def list_items
      @items.each do |item|
        puts "#{item[:quantity]} x #{item[:name]} @ #{item[:price]} each"
      end
    end
  end  
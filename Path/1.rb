# test_script.rb

require 'rspec'
require 'fileutils'

# Шлях до тестового каталогу
TEST_DIR = 'D:/Stek/Path/test'

# Описуємо поведінку скрипта
describe 'Duplicate file name checker' do
  before(:all) do
    # Створюємо тестову директорію
    FileUtils.mkdir_p(TEST_DIR)
    
    # Створюємо файли з однаковими назвами, але різними розширеннями
    File.write("#{TEST_DIR}/document.txt", "Some content")
    File.write("#{TEST_DIR}/document.docx", "Some content")
    File.write("#{TEST_DIR}/photo.jpg", "Some content")
    File.write("#{TEST_DIR}/photo.png", "Some content")
    File.write("#{TEST_DIR}/file1.txt", "Some content")
  end

  after(:all) do
    # Видаляємо тестову директорію та файли після тесту
    FileUtils.rm_rf(TEST_DIR)
  end

  it 'finds duplicate files with the same name but different extensions' do
    # Запускаємо основний скрипт, передаючи шлях до каталогу
    result = `ruby Path.rb "#{TEST_DIR}"` # Замість `script_name.rb` вкажіть ім'я вашого скрипта

    # Перевіряємо, чи виводяться правильно дублікати
    expect(result).to include("Знайдено файли з однаковими назвами (без урахування розширень):")
    expect(result).to include("документ: document.txt, document.docx")
    expect(result).to include("фото: photo.jpg, photo.png")
  end

  it 'does not find duplicates when there are no duplicate files' do
    # Створюємо ще один файл, щоб перевірити, чи не знайде дублікати
    File.write("#{TEST_DIR}/unique_file.txt", "Unique content")

    result = `ruby script_name.rb "#{TEST_DIR}"`

    # Перевіряємо, що дублікати не знайдені
    expect(result).to include("Дубльованих файлів не знайдено.")
  end
end

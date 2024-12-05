require 'json'
require 'date'

class Task
  attr_accessor :title, :deadline, :completed

  def initialize(title, deadline, completed = false)
    @title = title
    @deadline = Date.parse(deadline)
    @completed = completed
  end

  def to_hash
    { title: @title, deadline: @deadline.to_s, completed: @completed }
  end

  def self.from_hash(hash)
    new(hash['title'], hash['deadline'], hash['completed'])
  end
end

class TaskManager
  FILE_NAME = 'tasks.json'

  def initialize
    @tasks = load_tasks
  end

  def add_task(title, deadline)
    @tasks << Task.new(title, deadline)
    save_tasks
  end

  def delete_task(index)
    @tasks.delete_at(index)
    save_tasks
  end

  def edit_task(index, new_title = nil, new_deadline = nil, new_status = nil)
    task = @tasks[index]
    task.title = new_title if new_title
    task.deadline = Date.parse(new_deadline) if new_deadline
    task.completed = new_status unless new_status.nil?
    save_tasks
  end

  def list_tasks
    @tasks.each_with_index do |task, index|
      puts "#{index + 1}. [#{task.completed ? '✔' : ' '}] #{task.title} - #{task.deadline}"
    end
  end

  def filter_tasks(status: nil, deadline: nil)
    filtered_tasks = @tasks
    filtered_tasks = filtered_tasks.select { |t| t.completed == status } unless status.nil?
    filtered_tasks = filtered_tasks.select { |t| t.deadline <= Date.parse(deadline) } if deadline
    filtered_tasks.each_with_index do |task, index|
      puts "#{index + 1}. [#{task.completed ? '✔' : ' '}] #{task.title} - #{task.deadline}"
    end
  end

  private

  def save_tasks
    File.write(FILE_NAME, JSON.pretty_generate(@tasks.map(&:to_hash)))
  end

  def load_tasks
    return [] unless File.exist?(FILE_NAME)

    JSON.parse(File.read(FILE_NAME)).map { |task_data| Task.from_hash(task_data) }
  end
end

def menu
  manager = TaskManager.new

  loop do
    puts "\nTask Manager Menu:"
    puts "1. Add task"
    puts "2. Delete task"
    puts "3. Edit task"
    puts "4. View all task"
    puts "5. Sort task"
    puts "6. Exit"
    print "Choose: "
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Name: "
      title = gets.chomp
      print "Deadline (YYYY-MM-DD): "
      deadline = gets.chomp
      manager.add_task(title, deadline)
    when 2
      manager.list_tasks
      print "Enter № task to del: "
      index = gets.chomp.to_i - 1
      manager.delete_task(index)
    when 3
      manager.list_tasks
      print "Enter № task to edit: "
      index = gets.chomp.to_i - 1
      print "New name (Enter to skip): "
      title = gets.chomp
      print "New deadline (YYYY-MM-DD) (Enter to skip): "
      deadline = gets.chomp
      print "All right? (Y/N, Enter to skip): "
      status = gets.chomp.downcase
      completed = status == 'Y' ? true : status == 'N' ? false : nil
      manager.edit_task(index, title.empty? ? nil : title, deadline.empty? ? nil : deadline, completed)
    when 4
      manager.list_tasks
    when 5
      print "Sort by Status (Y/N)? "
      status_input = gets.chomp.downcase
      status = status_input == 'Y' ? true : status_input == 'N' ? false : nil
      print "Sort by Deadline (YYYY-MM-DD)? "
      deadline = gets.chomp
      manager.filter_tasks(status: status, deadline: deadline.empty? ? nil : deadline)
    when 6
      break
    else
      puts "Wrong choise"
    end
  end
end

menu
require 'minitest/autorun'
require_relative 'task_manager'

class TestTaskManager < Minitest::Test
  def setup
    @manager = TaskManager.new
    @manager.add_task('Test task', '2024-12-31')
  end

  def teardown
    File.delete(TaskManager::FILE_NAME) if File.exist?(TaskManager::FILE_NAME)
  end

  def test_add_task
    @manager.add_task('New task', '2024-12-01')
    assert_equal 2, @manager.instance_variable_get(:@tasks).size
  end

  def test_delete_task
    @manager.delete_task(0)
    assert_equal 0, @manager.instance_variable_get(:@tasks).size
  end

  def test_edit_task
    @manager.edit_task(0, 'Edit task', '2025-01-01', true)
    task = @manager.instance_variable_get(:@tasks).first
    assert_equal 'Edit task', task.title
    assert_equal Date.parse('2025-01-01'), task.deadline
    assert task.completed
  end
end

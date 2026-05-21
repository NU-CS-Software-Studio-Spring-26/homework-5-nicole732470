require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "defaults high_priority to false" do
    todo = Todo.new(description: "Example")

    assert_not todo.high_priority
  end

  test "can save with high_priority true" do
    todo = Todo.create!(description: "Important", high_priority: true)

    assert todo.high_priority
  end
end

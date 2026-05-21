https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-nicole732470/tree/hw5

https://github.com/nicole732470/todoapp/blob/main/.cursorignore

https://github.com/nicole732470/todoapp/blob/main/.cursor/rules/rails-conventions.mdc
https://github.com/nicole732470/todoapp/blob/main/.cursor/rules/security.mdc



Where in this codebase is todo creation and validation error rendering currently implemented? Cite the exact files and line numbers. Do not propose changes.

Todo creation
Routing — POST /todos comes from resources :todos (only :new is excluded):


routes.rb
Lines 1-3
Rails.application.routes.draw do
  resources :todos, except: [:new]
  get "new_todo", to: "todos#new", as: :new_todo
New form (GET) — TodosController#new builds an empty @todo:


todos_controller.rb
Lines 13-16
  # GET /todos/new
  def new
    @todo = Todo.new
  end
Create (POST) — TodosController#create builds from strong params, saves, and branches on success/failure:


todos_controller.rb
Lines 22-35
  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)
    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end
Strong parameters — permitted fields for create:


todos_controller.rb
Lines 73-76
    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:description, :due_date, :done)
    end
New page — renders the shared form partial:


new.html.erb
Lines 1-5
<% content_for :title, "New todo" %>
<h1>New todo</h1>
<%= render "form", todo: @todo %>
Form submission — form_with(model: todo) posts to the create action:


_form.html.erb
Lines 1-1
<%= form_with(model: todo) do |form| %>
Validation
There are no model validations defined:


todo.rb
Lines 1-2
class Todo < ApplicationRecord
end
The schema also does not enforce description (nullable string):


schema.rb
Lines 14-20
  create_table "todos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.boolean "done", default: false, null: false
    t.datetime "due_date"
    t.datetime "updated_at", null: false
  end
So in practice, @todo.save in #create currently succeeds unless something else fails at the DB layer.

Validation error rendering
HTML — on failed save, #create re-renders new (lines 30–31 above), which again renders _form.html.erb. Errors are displayed here:


_form.html.erb
Lines 2-12
  <% if todo.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(todo.errors.count, "error") %> prohibited this todo from being saved:</h2>
      <ul>
        <% todo.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
JSON — errors are returned directly from the controller:


todos_controller.rb
Lines 31-32
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
Tests
There is a happy-path create test, but no test for validation failure rendering:


todos_controller_test.rb
Lines 18-24
  test "should create todo" do
    assert_difference("Todo.count") do
      post todos_url, params: { todo: { description: @todo.description } }
    end
    assert_redirected_to todo_url(Todo.last)
  end
test/models/todo_test.rb has no validation tests (file is essentially empty).




require "active_record"

class Todo < ActiveRecord::Base
  @todolist = { "Overdue" => [], "Due Today" => [], "Due Later" => [] }

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_date == Date.today ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end
  def self.to_displayable_list(category)
    @todolist[category].each do |todo|
      puts todo.to_displayable_string
    end
  end
  def self.show_list
    all.each do |todo|
      if todo.due_date < Date.today
        @todolist["Overdue"] << todo
      elsif todo.due_date == Date.today
        @todolist["Due Today"] << todo
      else
        @todolist["Due Later"] << todo
      end
    end
    puts "My Todo-list\n\n"
    puts "Overdue\n"
    to_displayable_list ("Overdue")
    puts "\n\n"
    puts "Due Today\n"
    to_displayable_list ("Due Today")
    puts "\n\n"
    puts "Due Later\n"
    to_displayable_list ("Due Later")
    puts "\n\n"
  end
  def self.add_task(h)
    create!(todo_text: h[h.keys[0]], due_date: Date.today + h[h.keys[1]], completed: false)
  end
  def self.mark_as_complete!(todo_id)
    todo=find(todo_id)
    todo.completed = true
    todo.save
    return todo
  end
end

require 'titleize'

@contact_list = [{
    name: 'John',
    number: '801-928-6436'
  },
  {
    name: 'Sue',
    number: '801-321-1234'
  }]

def separator
  puts
end

def menu 
  puts "Contacts"
  puts "Select the Corresponding Number to Choose an Option"
  puts "1) Create a Contact"
  puts "2) View Contacts"
  puts "3) Delete a Contact"
  puts "4) Edit Existing Contact"
  puts "5) Find Contact by Name or Phone Number"
  puts "6) Exit"
  menu_options
end

def menu_options
  user_input = gets.strip.to_i
  case user_input
  when 1
    create_contact
  when 2
    view_contact
  when 3
    delete_contact
  when 4
    edit_contact
  when 5
    find_contact
  when 6
    exit
  else
    puts "Invalid Response, Please Try Again"
    menu_options
  end
  separator
end

def create_contact
  separator
  get_name
  get_number
  @new_contact = { name: @name, number: @number }
  @contact_list << @new_contact
  separator
  menu
end

def get_name
  puts "Enter the Name: "
  @name = gets.strip.titleize
end

def get_number
  puts "Enter Phone Number (XXX-XXX-XXXX): "
  @number = gets.strip
  pattern = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
  if pattern.match(@number)
    @number = @number.gsub(/(^(\+\d{1,2}\s)?)/, '')
    @number = @number.gsub(/\-*\(*\)*\s*\.*/, '')
    @number = @number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/, '\1-\2-\3')
  else
    puts "Invalid Phone Number"
    get_number
  end
end

def view_contact
  separator
  @contact_list.each_with_index do |i, index|
    puts "#{index + 1}) #{i[:name]}: #{i[:number]}"
  end
  separator
  menu
end

def view_only_contact
  @contact_list.each_with_index do |i, index|
    puts "#{index + 1}) #{i[:name]}: #{i[:number]}"
  end
end

def delete_contact
  separator
  puts "Which Contact Would You Like to Delete?"
  view_only_contact
  go_back
  delete_contact_menu
  separator
  menu
end

def go_back
  puts "#{@contact_list.size + 1}) Go Back"
end


def delete_contact_menu
  user_input = gets.strip.to_i
  if user_input == @contact_list.size + 1
    separator
    menu
  elsif user_input > 0 && user_input <= @contact_list.size
    @contact_list.delete_at(user_input - 1)
  else
    puts "Invalid Input, Try Again"
    delete_contact_menu
  end
end

def edit_contact
  separator
  puts "Which Contact Would You Like to Edit?"
  view_only_contact
  go_back
  edit_contact_menu
  menu
end

def edit_contact_menu
  user_input = gets.strip.to_i
  if user_input == @contact_list.size + 1
    separator
    menu
  elsif user_input > 0 && user_input <= @contact_list.size
    @change_this_contact = user_input
    change_contact_script
  else
    puts "Invalid Input, Try Again"
    edit_contact_menu
  end
end

def change_contact_script
  separator
  puts "Would You Like to Change the Name? (y/n)"
  puts "Type 'back' to Go Back"
  user_input = gets.strip
  case user_input
  when "y"
    change_contact_name
  when "n"
    @new_name = @contact_list[@change_this_contact - 1][:name]
    change_contact_number
  when "back"
    separator
    menu
  else
    puts "Invalid Input, Try Again"
    change_contact_script
  end
end

def change_contact_name
  separator
  puts "Enter New Name: "
  @new_name = gets.strip.titleize
  separator
  puts "Update Phone Number? (y/n)"
  user_input = gets.strip
  case user_input
  when "y"
    change_contact_number
  when "n"
    @new_number = @contact_list[@change_this_contact - 1][:number]
    save_new_contact
    separator
    menu
  else
    puts "Invalid Input, Try Again"
    change_contact_name
  end
end

def save_new_contact
  @updated_contact = { name: @new_name, number: @new_number }
  @contact_list.delete_at(@change_this_contact - 1)
  @contact_list << @updated_contact
end

def change_contact_number
  separator
  puts "Enter New Phone Number (XXX-XXX-XXXX): "
  @new_number = gets.strip
  pattern = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
  if pattern.match(@new_number)
    @new_number = @new_number.gsub(/(^(\+\d{1,2}\s)?)/, '')
    @new_number = @new_number.gsub(/\-*\(*\)*\s*\.*/, '')
    @new_number = @new_number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/, '\1-\2-\3')
    save_new_contact
  else
    puts "Invalid Phone Number"
    change_contact_number
  end
  separator
end

def find_contact
  separator
  puts "Enter the Name or Phone Number"
  @find_me = gets.strip.titleize
  define_number_rules
  if @contact_list.select{|num| num[:number] == @find_me_new}.length > 0
    number_match = @contact_list.select{|num| num[:number] == @find_me_new}
    number_match.each do |i|
      puts "#{i[:name]}: #{i[:number]}"
    end
  else
    check_name
  end
separator
menu
end

def check_name
  if @contact_list.select{|i| i[:name].include?(@find_me)}.length > 0
    name_match = @contact_list.select{ |i| i[:name].include?(@find_me)}
    name_match.each do |i|
      puts "#{i[:name]}: #{i[:number]}"
    end
  else
    reject_rules
  end
separator
menu
end

def define_number_rules
  @find_me_new = @find_me.gsub(/(^(\+\d{1,2}\s)?)/, '')
  @find_me_new = @find_me.gsub(/\-*\(*\)*\s*\.*/, '')
  @find_me_new = @find_me.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/, '\1-\2-\3')
end

def reject_rules
  @find_me = @find_me.gsub(/(^(\+\d{1,2}\s)?)/, '')
  @find_me = @find_me.gsub(/\-*\(*\)*\.*/, '')
  @find_me = @find_me.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/, '\1-\2-\3')
  puts "We don't have #{@find_me} in your contacts!"
  find_contact
end

menu
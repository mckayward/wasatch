require_relative "table"
require "nexmo"
require_relative "secrets"

base_table = Table.new

loop do
  check_table = Table.new
  
  base_table.difference(check_table)  

  base_table = check_table

  sleep(15)
end

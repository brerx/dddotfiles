require 'pry-doc'
require 'pry-toys'
require 'pry-byebug'
require 'pry-theme'
require 'pry-inline'

Pry.config.theme = 'tomorrow'

# === Listing config ===
# Better colors - by default the headings for methods are too
# similar to method name colors leading to a "soup"
# These colors are optimized for use with Solarized scheme
# for your terminal
# Pry.config.ls.separator = "\n" # new lines between methods
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
# Pry.config.ls.private_method_color = :bright_black

# Use awesome_print (or amazing_print)
begin
  require 'awesome_print'
  AwesomePrint.pry!
rescue LoadError => e
  begin
    puts "no awesome_print :( #{e}"
    puts 'trying amazing_print'
    require 'amazing_print'
    AmazingPrint.pry!
  rescue LoadError => err2
    puts "no awesome_print :( #{err2}"
  end
end

puts 'config loaded!'

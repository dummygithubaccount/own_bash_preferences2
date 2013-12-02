#Resque.inline = false
#b/config/environments/development.rb

#git pull 
#whoops?
#git reset HEAD@{1}

#change git_log_search to look for line after date and befor commit with the spaces either side, along with the number, and a link to the github diff page, or the diff option on git log:
=begin
commit 8382dfcab53a0d0ea869b241395253b27b2814b1
Author: kayodeowojori <my_email@yahoo.com>
Date:   Fri May 10 14:41:35 2013 +0100

    [#573] MM/PM : shortening reference and changing checksum to capture transposition errors

commit bf02d48c3d2b9696e7fd3a4eaa2f64dd99502c01
Author: kayodeowojori <my_email@yahoo.com>
Date:   Tue May 7 13:01:31 2013 +0100
=end

#git log -p   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#http://stackoverflow.com/questions/1050047/how-to-run-rails-console-in-the-test-environment-and-load-test-helper-rb

#def get_next_reference_sequence_num
#    self.class.connection.execute("select NEXTVAL('customer_reference_seq');").values.first.first
#  end

class ConvertToSql
  attr_accessor :table_name, :file_lines, :columns, :data_types_hash, :sql_command
  
  TMPFILE = '/home/edam/own_ruby_scripts/update_ptp_dev/tmp/insert_command_123456789.psql'

  def initialize table_name
    self.table_name = table_name
    self.file_lines = retrieve_data
    self.columns = init_columns
    self.data_types_hash = build_data_types_hash
    
  end
 
  def perform
    create_sql_command
    write_to_file
    insert_into_table
  end


  private #################################################
  
  def convert_line_to_array_of_hashes file_line
    file_line.split('|').collect(&:strip).each_with_index.map {|element,i| data_format(element, columns[i])}
  end  
   
  def write_to_file
    file = File.open(TMPFILE, "w")
    file.write(sql_command)
    file.close
  end

  def create_sql_command
    formatted_columns = columns.collect {|element| "\"#{element}\""}
    puts "(#{formatted_columns.join(', ')})"
    sql_command = "INSERT INTO #{table_name} (#{formatted_columns.join(', ')}) VALUES \n"
    file_lines.delete(file_lines[0])
    file_lines.delete(file_lines[-1])
    
    file_lines.each do |line| 
      sql_command += create_sql_command_parameters( convert_line_to_array_of_hashes(line), columns)
    end
     
    self.sql_command = (sql_command[0..-3]+";")    
  end
  
  def insert_into_table
    delete_all_rows
    #puts `sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U developer -d competition_management_development -f #{TMPFILE};
    #      bash /home/edam/own_bash_scripts/secure_delete.sh #{TMPFILE}`.split('\n').join("\n")  #check this executes
    puts `sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U developer -d customerservice_development -f #{TMPFILE};
          bash /home/edam/own_bash_scripts/secure_delete.sh #{TMPFILE}`.split('\n').join("\n")  #check this executes
  end
   

  def retrieve_data
    #`sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U ad -d dummy_test -c "SELECT * FROM #{table_name}"`.split("\n")
    #`sudo /usr/bin/psql  -h 172.17.0.245 -p 5432 -U developer -d competition_management_uat -c "SELECT * FROM #{table_name}"`.split("\n")
    `sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U developer -d customerservice_development -c "SELECT * FROM #{table_name}"`.split("\n")
  end

  # replaced with retrieve_data, left for reference and posible future use
  #def create_array_from_file file_path
  #  self.file_lines = File.read(file_path).split("\n")
  #end
  
  def init_columns
    file_lines.delete(file_lines[0]).split('|').collect(&:strip)
  end
  
  def get_data_types
    #`sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U ad -d dummy_test -c "\\d+ teams" | grep "|" | awk '{print $1, $2, $3}'` 
    #`sudo /usr/bin/psql  -h 172.17.0.245 -p 5432 -U developer -d competition_management_uat -c "\\d+ #{table_name}" | grep "|" | awk '{print $1, $2, $3}'` 
    `sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U developer -d customerservice_test -c "\\d+ #{table_name}" | grep "|" | awk '{print $1, $2, $3}'`  
  end
  
  def data_format element, column
    format = data_types_hash[column.to_sym]
    case format
    when 'integer'
      if element.empty?
        return {column => "NULL"}
      end
      return {column => element}
        
    when 'character'
      if element.split('\'').length == 2 
        element = element.split('\'').join('\'\'')
      end     
      return {column => "'#{element}'"}
      
    when 'timestamp'
      if element.split('\'').length == 2 
        element = element.split('\'').join('\'\'')
      end     
      return {column => "'#{element}'"}
      
    when 'boolean' #check if correct function
      element = element.split('\'').join('\'\'')
      if element == 't'
        element = "TRUE"
      elsif element == 'f'
        element = "FALSE"
      else
        element = "NULL"
      end        
      return {column => "#{element}"}
    end
  end
  
  def build_data_types_hash
    raw_data = get_data_types
    trimmed_data = raw_data[14..-1].split("\n")
    formatted_data = trimmed_data.collect {|element| element.split('|').collect(&:strip) }    
    hash_string = "{ #{ formatted_data.collect { |e| ":#{e[0] } => '#{ e[1] }'" }.join(', ') } }" #ignore colour, bug in software"
    eval hash_string  
  end
  
  def delete_all_rows
    #`sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U developer -d competition_management_development -c "DELETE FROM #{table_name}"`
    `sudo /usr/bin/psql  -h 127.0.0.1 -p 5432 -U developer -d customerservice_development -c "DELETE FROM #{table_name}"`
  end
  
  def create_sql_command_parameters file_line_as_array, columns
    "  (#{file_line_as_array.each_with_index.map{ |element,i| element[columns[i]]}.join(', ')}),\n"   
  end
end

#need to put in a check for the tables existence
#file_string = `sudo /usr/bin/psql  -h 172.17.0.245 -p 5432 -U developer -d competition_management_uat -c"<insert_commands>"`
#http://tech.natemurray.com/2007/03/ruby-shell-commands.html





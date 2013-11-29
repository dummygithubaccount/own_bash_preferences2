class ConvertToSql
  attr_accessor :file_lines, :table_name

  module TypeOfTable
    TEAMS = { :id => 'int', :name => 'str', :created_at => 'str', :updated_at => 'str', :external_id => 'str'}
    #fixtures
    #competitions
  end

  def initialize table_name
    self.table_name =  table_name
  end

  def table_format
    ("ConvertToSql::TypeOfTable::"+table_name.upcase).constantize
  end

  def create_array_from_file file_path
    self.file_lines = File.read(file_path).split("\n")
  end

  def columns
    file_lines[0].split('|').collect(&:strip)
  end


  # "33 | Uruguay | 2012-08-01 09:00:39.043178 | 2012-10-06 00:31:06.880529 | 5796"
  def convert_line_to_array_of_hashes file_line
    #file_line.split('|').collect(&:strip).collect {|element| {columns}}
    file_line.split('|').collect(&:strip).each_with_index.map {|element,i| {columns[i] => element }}
  end


  #[{"id"=>"33"}, {"name"=>"Uruguay"}, {"created_at"=>"2012-08-01 09:00:39.043178"}, {"updated_at"=>"2012-10-06 00:31:06.880529"}, {"external_id"=>"5796"}]
  def apply_table_format_to_line_elements line
    line.each do |element|

    end
  end

  def create_sql_line file_line_as_array

  end
end

# create_array_from_file
# convert_line_to_array
# apply_table_format_to_line_elements

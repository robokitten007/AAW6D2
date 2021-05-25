require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL)
    SELECT *
    FROM #{self.table_name}
    SQL
    @columns = cols.first.map{|name| name.to_sym}
   
  end

  def self.finalize!  #class method
    self.columns.each do |col|
      define_method(col) do 
        self.attributes[col]
      end 

      define_method("#{col}=") do |value|
        self.attributes[col] = value
      end 
    end 

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.underscore.pluralize

    # ...
  end

  def self.all
    
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {}) #instance method
      params.each do |attr_name, value|
        attr_name = attr_name.to_sym
        if self.class.columns.include?(attr_name)  #self.class to access class method within an instance
          self.send("#{attr_name}=", value)
        else 
          raise "unknown attribute '#{attr_name}'"
        end 
      end 
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end

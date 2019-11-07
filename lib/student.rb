class Student

  attr_accessor :name, :grade
  attr_reader :id

  ## always set id = nil so that the id can be assigned in
  ## your database, ensuring unique id's.
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  ## creates table in database if it doesn't already exist
  def self.create_table
    sql =  <<-SQL
    CREATE TABLE IF NOT EXISTS students ( 
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
    end

  ## drops the table from your database
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
      DB[:conn].execute(sql)
  end

  ## saves the attributes of an instance to your table
  ## pulls the id from the table and saves it to the 
  ## instances @id attribute
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  ## handles the instantiation of an object in ruby, creating
  ## a row with this instances attributes in your table, and
  ## returning the newly instantiated object
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn] 
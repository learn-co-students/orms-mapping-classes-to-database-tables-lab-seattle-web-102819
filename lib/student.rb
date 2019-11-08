class Student
  attr_accessor :name, :grade 
  attr_reader :id 
 def initialize (name, grade, id=nil)
    @name = name 
    @grade = grade 
    @id = id 
 end 
  
 
 def self.create_table 
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        
        )
        SQL
    DB[:conn].execute(sql) 
  end 

  def self.drop_table 

    sql = "DROP table IF EXISTS students"
    DB[:conn].execute(sql)

  end 

  def save 
    sql = <<-SQL
      insert into students (name, grade)
      values (?, ?)
    SQL
    # sqlstr = "insert into students (name, grade) values (\"" + self.name + "\", \"" + self.grade + "\")"
    DB[:conn].execute(sql, self.name, self.grade)
    # DB[:conn].execute(sqlstr)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create(grade:, name:)
     student = Student.new(name, grade)
     student.save
     student
  end 
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end


def get_format
  if request.accept.include? "application/json"
    "json"
  elsif request.accept.include? "application/xml"
    "xml"
  else
    "txt"
  end
end

def get_mimetype
  if request.accept.include? "application/json"
    "application/json"
  elsif request.accept.include? "application/xml"
    "application/xml"
  else
    "text/txt"
  end
end

class Todo
  attr_accessor :id, :name, :completed
  
  def initialize(id, name, status)
    @id = id
    @name = name
    @completed = status
  end
  
  def status
    puts "status"
    puts @completed
    if @completed
      "completed"
    else
      "uncompleted"
    end
  end
end

def save(memory)
  marshal_dump = Marshal.dump(memory)
  file = File.new("memory.dat",'w')
  file.write marshal_dump
  file.close
end

def load_memory
  file = File.open("memory.dat", 'r')
  obj = Marshal.load file.read
  file.close
  obj
end
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
end
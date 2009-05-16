module Bananajour::Bonjour
  
  # methods that call Bonjour, and little model wrappers for the response packets
  
  class Repo
    attr_accessor :name, :uri, :person 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def person=(hsh)
      @person = Person.new(hsh)
    end
    
    def ==(other)
      self.uri == other.uri
    end
    
    alias_method :bananajour, :person
  end
  
  class Person
    attr_accessor :name, :uri 
    def initialize(hsh)
      hsh.each { |k,v| self.send("#{k}=", v) }
    end
    
    def ==(other)
      self.uri == other.uri
    end
  end
  
  def advertise!
    puts "* Advertising on bonjour"

    tr = DNSSD::TextRecord.new
    tr["uri"] = web_uri
    tr["name"] = Bananajour.config.name
    DNSSD.register("#{config.name}'s bananajour", "_bananajour._tcp", nil, web_port, tr) {}
  end
  
  def network_repositories
    yaml = `#{Fancypath(__FILE__).dirname/'../../bin/bananajour'} network_repositories`
    YAML.load(yaml).map { |hsh| Repo.new(hsh) }
  end
  
  def people
    yaml = `#{Fancypath(__FILE__).dirname/'../../bin/bananajour'} people`
    YAML.load(yaml).map { |hsh| Person.new(hsh) }
  end

  def other_people
    people.reject { |p| p.uri == self.web_uri }
  end
  
end
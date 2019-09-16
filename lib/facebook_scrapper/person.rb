module FacebookScrapper
  class Person
    attr_accessor :name, :pofile_link, :add_as_friend_link

    def initialize
      self.name = ""
      self.pofile_link = ""
      self.add_as_friend_link = ""
    end

    def to_str
      s = ""
      s += "#{self.name}:\n"
      s += "Profile Link: #{self.pofile_link}"
      if self.add_as_friend_link != ""
        s += "Addlink ->: #{self.add_as_friend_link}"
      end
      return s
    end
  end
end

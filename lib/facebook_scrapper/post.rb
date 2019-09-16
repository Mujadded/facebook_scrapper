module FacebookScrapper
  class Post
    attr_accessor :owner, :text, :like_count, :comment_count, :like_link, :time, :post_owner_link, :comment_link, :more_link

    def initialize
      self.owner = ""
      self.text = ""
      self.like_count = 0
      self.comment_count = 0
      self.time = ""
      self.post_owner_link = ""
      self.comment_link = ""
      self.like_link = ""
      self.more_link = ""
    end

    def to_h
      hash = {}
      instance_variables.each do |var|
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      end
      return hash
    end

    def to_json
      to_h.to_json
    end

    def to_str
      s = "\nPost by #{self.owner}: "
      s += "#{self.text} \n"
      s += "Likes: #{self.like_count.to_s} - "
      s += "Comments: #{self.comment_count.to_s} - "
      s += "#{self.time} "
      s += " - Privacy: #{self.privacy}\n-"
      s += "\n Comment -> #{self.comment_link}\n"
      return s
    end
  end
end

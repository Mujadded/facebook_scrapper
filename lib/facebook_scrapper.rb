require "selenium-webdriver"

class FacebookScrapper
  def initialize
    @driver = Selenium::WebDriver.for :chrome
  end

  def toBasicUrl(url)
    if url.include? "m.facebook.com"
      return url.gsub!("m.facebook.com", "mbasic.facebook.com")
    elsif url.include? "www.facebook.com"
      return url.gsub!("www.facebook.com", "mbasic.facebook.com")
    else
      return url
    end
  end

  def get(url)
    @driver.get(toBasicUrl(url))
  end

  def get_driver
    return @driver
  end

  def login(email, password)
    url = "https://mbasic.facebook.com"
    get(url)
    email_box = @driver.find_element(name: "email")
    email_box.send_keys(email)
    password_box = @driver.find_element(name: "pass")
    password_box.send_keys(password)
    password_box.submit
    # Bypass facebook OneClick Login
    if @driver.find_element(class: "bi")
      @driver.find_element(class: "bp").click()
    end
    begin
      @driver.find_element(name: "xc_message")
      puts "Logged in"
      return true
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      body = @driver.find_element(tag_name: "body").text
      if (body.include?("Enter login code to continue"))
        puts "You 2 factor is turned on. Authenticate it and try again"
      else
        puts "Failed to login"
        @driver.save_screenshot("login_failed.png")
      end
      return false
    end
  end

  def logout
  end

  def write_post_to_url(url, text)
    begin
      get(url)
      textBox = @driver.find_element(name: "xc_message")
      textBox.send_keys(text)
      textbox.submit
      return true
    rescue => e
      puts "Failed to post in #{url} for error of #{e}"
      return false
    end
  end

  def get_posts_group(url)
    get(url)
    posts = []
    all_posts = @driver.find_element(id: "m_group_stories_container").find_elements(css: "div[role='article']")
    puts "Found #{all_posts.length} posts"
    all_posts.each do |raw_post|
      new_post = get_post_object(raw_post)
      puts new_post
      posts.push(new_post.to_json) if new_post
    end
    return posts
  end

  def get_posts_from_home
    get("https://mbasic.facebook.com")
    posts = []
    all_posts = @driver.find_elements(css: "div[role='article']")
    puts "Found #{all_posts.length} posts"
    all_posts.each do |raw_post|
      new_post = get_post_object(raw_post)
      posts.push(new_post) if new_post
    end
    return posts
  end

  def post_in_group(group_url, text)
    get(group_url)
    begin
      text_box = @driver.find_element(name: "xc_message")
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @driver.save_screenshot("no_group_found.png")
      puts "Group url dosnt exist"
      return false
    end
    text_box.send_keys(text)
    text_box.submit
    return true
  end

  def get_post_object(raw_post)
    begin
      new_post = raw_post.find_element(css: "div[role='article']")
      like_data = raw_post
    rescue
      new_post = raw_post
      like_data = raw_post
    end
    post = Post.new
    all_links = like_data.find_elements(tag_name: "a")

    # # dont track not post things
    return nil unless all_links[-7].text.include?("Like")

    post.owner = new_post.find_elements(tag_name: "a")[0].text
    post.text = new_post.find_element(tag_name: "p").text
    post.like_count = all_links[-7].text.to_i
    post.comment_count = all_links[-4].text.to_i
    post.time = new_post.find_element(tag_name: "abbr").text
    post.post_owner_link = all_links[0].attribute("href")
    post.comment_link = all_links[-4].attribute("href")
    post.like_link = like_data.find_element(link_text: "Like").attribute("href")
    post.more_link = all_links[-1].attribute("href")
    return post.to_h
  rescue
    return nil
  end
end

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

# def get_posts(url)
#   driver.get(url)
#   driver.find_element(id:'m_group_stories_container').find_elements(css: "div[role='article']")[0].find_element(tag_name: 'p').text
#   driver.find_element(id:'m_group_stories_container').find_elements(css: "div[role='article']")[1].find_element(link_text: 'Full Story').attribute('href')
# end

require "selenium-webdriver"

module FacebookScrapper
  class Scrapper
    def initialize
      @driver = Selenium::WebDriver.for :chrome
      @logged_in = false
    end

    def is_logged_in?
      @logged_in
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
        @logged_in = true
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

    def get_posts_from_group_url(url, keywords = [])
      get(url)
      posts = []
      all_posts = @driver.find_element(id: "m_group_stories_container").find_elements(css: "div[role='article']")
      all_posts.each do |raw_post|
        new_post = get_post_object(raw_post, keywords)
        posts.push(new_post) if new_post
      end
      puts "Found #{posts.length} posts"
      return posts
    end

    def get_posts_from_home(keywords = [])
      get("https://mbasic.facebook.com")
      posts = []
      all_posts = @driver.find_elements(css: "div[role='article']")
      all_posts.each do |raw_post|
        new_post = get_post_object(raw_post, keywords)
        posts.push(new_post) if new_post
      end
      puts "Found #{posts.length} posts"
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

    private

    def toBasicUrl(url)
      if url.include? "m.facebook.com"
        return url.gsub!("m.facebook.com", "mbasic.facebook.com")
      elsif url.include? "www.facebook.com"
        return url.gsub!("www.facebook.com", "mbasic.facebook.com")
      else
        return url
      end
    end

    def get_post_object(raw_post, keywords = [])
      begin
        new_post = raw_post.find_element(css: "div[role='article']")
        like_data = raw_post
      rescue
        new_post = raw_post
        like_data = raw_post
      end
      post = Post.new
      all_links = like_data.find_elements(tag_name: "a")

      # dont track not post things
      return nil unless all_links[-7].text.include?("Like")

      with_share = like_data.find_elements(link_text: "Share").empty? ? 1 : 0

      post.owner = new_post.find_elements(tag_name: "a")[0].text
      post.text = new_post.find_element(tag_name: "p").text
      post.like_count = all_links[-7 - with_share].text.to_i
      post.comment_count = all_links[-4 - with_share].text.to_i
      post.time = new_post.find_element(tag_name: "abbr").text
      post.post_owner_link = all_links[0].attribute("href")
      post.comment_link = all_links[-4 - with_share].attribute("href")
      post.like_link = like_data.find_element(link_text: "Like").attribute("href")
      post.more_link = all_links[-1].attribute("href")

      keyword_included = keywords.any? { |keyword| post.text.include?(keyword) }

      if (keyword_included || keywords.empty?)
        return post
      end

      return nil
    rescue
      return nil
    end
  end
end

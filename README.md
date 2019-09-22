# Welcome to FacebookScrapper Gem 👋
![Version](https://img.shields.io/badge/version-0.4.0-blue.svg?cacheSeconds=2592000)
[![Twitter: mujadded](https://img.shields.io/twitter/follow/mujadded.svg?style=social)](https://twitter.com/mujadded)

> This is gem that gives you a way to gather data from facebook without using the api. For example for a bot or maybe for pet project. Using this gem we can scrap data from home or from a group. We can also post in group and also post status. It totally up to you how you want to proceed

## Inspired from

This is inspired from https://github.com/hikaruAi/FacebookBot the bot is a inspiration itself :smile:

## Dependencies

To use this gem properly we need to install selenium webdriver and also the chrome driver

### Selenium gem install

```sh
gem install selenium-webdriver
```

### Chrome driver

To install the chrome driver, please follow:

For Ubuntu:
[Ubutu install](https://tecadmin.net/setup-selenium-chromedriver-on-ubuntu/)

For Mac:
[Mac install](https://www.kenst.com/2015/03/installing-chromedriver-on-mac-osx/)

For Windows:
[Windows install](https://www.kenst.com/2019/02/installing-chromedriver-on-windows/)

## Install

To install the latest gem 

```sh
gem install facebook_scrapper
```

## Usage

First initalize the scrapper.

```sh
facebook = FacebookScrapper::Scrapper.new
```

Next step is to log in.

```sh
facebook.login('email', 'password')
```

If you have 2 step authenticate maybe authenticate the device then try again.

To check if log in was successfull
```
  facebook.is_logged_in?

```
Then to get posts

```sh
facebook.get_posts_from_home(keywords) // keywords are array of string and optional

facebook.get_posts_from_group_url(url, keywords) // keywords is optional
```

To write the post in url

```sh
facebook.write_post_to_url(url, text) //url you want to post to and text you want to write
```

## Author

👤 **Mujadded Al Rabbani Alif**

* Twitter: [@mujadded](https://twitter.com/mujadded)
* Github: [@mujadded](https://github.com/mujadded)

## Show your support

Give a ⭐️ if this project helped you!

## Contributions

Contributions are most welcome 😍

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_

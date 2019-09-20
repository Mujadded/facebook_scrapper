# Welcome to FacebookScrapper Gem 👋
![Version](https://img.shields.io/badge/version-0.2.5-blue.svg?cacheSeconds=2592000)
[![Twitter: mujadded](https://img.shields.io/twitter/follow/mujadded.svg?style=social)](https://twitter.com/mujadded)

> This is gem that gives you a way to gather data from facebook without using the api

## Install

```sh
gem install facebook_scrapper
```

## Usage

```sh
facebook = FacebookScrapper::Scrapper.new

facebook.login('email', 'password')

facebook.get_posts_from_home

facebook.get_posts_from_group_url
```

## Author

👤 **Mujadded Al Rabbani Alif**

* Twitter: [@mujadded](https://twitter.com/mujadded)
* Github: [@mujadded](https://github.com/mujadded)

## Show your support

Give a ⭐️ if this project helped you!


***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
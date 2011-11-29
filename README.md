# Health Mode

Health mode is a tiny Sinatra app that provides an API interface to the system metrics. System metrics such as system load, disk space, and memory are exposed. This makes it easy to integrate with other web services such as twitter or twilio.

## Installation

  gem install health_mode

## Dependencies

Health mode is meant to be ran on a Linux server. It has been tested on Ubuntu and Centos.

## Usage

Health mode can be ran directly from the command line.

  # runs the Sinatra app on the default port 5678
  health-mode-agent

  # sets the port to 4567
  health-mode-agent -p 4567

  # see all the command line options
  health-mode-agent -h

### Security

By default, health mode only allows requests from localhost. If you have a trusted host, let health mode accept requests from it

  # stating an authorized host
  health-mode-agent -a foo.com

Or for debugging purposes, you may want to accept all requests

  # accept requests from public
  health-mode-agent -u

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)

## Copyright

Copyright (c) 2011 Wong Liang Zan. See LICENSE for details.


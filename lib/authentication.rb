require 'socket'

module HealthMode
  module Authentication
    @@authorized_host = "127.0.0.1"
    @@public_access = false

    def self.set_authorized_host(hostname)
      @@authorized_host = hostname
    end

    def self.set_public_access
      @@public_access = true
    end

    def self.from_authorized_host?(req)
      req.ip == "127.0.0.1" ||
        @@public_access ||
        Socket.getaddrinfo(@@authorized_host, nil)[0][2] == req.ip
    end
  end
end

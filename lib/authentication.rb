require 'socket'

module BroadcastMode
  module Authentication
    HOST = 'localhost'

    def self.from_authorized_host?(req)
      req.ip == "127.0.0.1" ||
        Socket.getaddrinfo(HOST, nil)[0][2] == req.ip
    end
  end
end

//
//  Socket.swift
//  ReactSockets
//
//  Created by Henry Kirkness on 10/05/2015.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

import Foundation

@objc(SocketIO)
class SocketIO: RCTEventEmitter {

  var socket: SocketIOClient!
  var connectionSocket: NSURL!

  /**
  * Tell RN what events we are dispatching
  */

  override func supportedEvents() -> [String]! {
    return ["socketEvent"]
  }

  /**
  * Initialize and configure socket
  */

  @objc func initialize(connection: String, config: NSDictionary) -> Void {
    connectionSocket = NSURL(string: connection);

    // Connect to socket with config
    self.socket = SocketIOClient(
      socketURL: self.connectionSocket,
      config:config as? [String : AnyObject]
    )

    // Initialize onAny events
    self.onAnyEvent()
  }

  /**
  * Manually join the namespace
  */

  @objc func joinNamespace(namespace: String)  -> Void {
        self.socket.joinNamespace(namespace);
  }

  /**
  * Leave namespace back to '/'
  */

  @objc func leaveNamespace() {
    self.socket.leaveNamespace();
  }

  /**
  * Exposed but not currently used
  * add NSDictionary of handler events
  */

  @objc func addHandlers(handlers: NSDictionary) -> Void {
    for handler in handlers {
      self.socket.on(handler.key as! String) { data, ack in
        self.sendEventWithName("socketEvent", body: handler.key as! String)
      }
    }
  }

  /**
  * Emit event to server
  */

  @objc func emit(event: String, items: AnyObject) -> Void {
    self.socket.emit(event, items)
  }

  /**
  * PRIVATE: handler called on any event
  */

  private func onAnyEventHandler (sock: SocketAnyEvent) -> Void {
    if let items = sock.items {
      self.sendEventWithName("socketEvent",
        body: ["name": sock.event, "items": items])
    } else {
      self.sendEventWithName("socketEvent",
        body: ["name": sock.event])
    }
  }

  /**
  * Trigger the event above on any event
  * Currently adding handlers to event on the JS layer
  */

  @objc func onAnyEvent() -> Void {
    self.socket.onAny(self.onAnyEventHandler)
  }

  // Connect to socket
  @objc func connect() -> Void {
    self.socket.connect()
  }

  // Reconnect to socket
  @objc func reconnect() -> Void {
    self.socket.reconnect()
  }

  // Disconnect from socket
  @objc func disconnect() -> Void {
    self.socket.disconnect()
  }
}

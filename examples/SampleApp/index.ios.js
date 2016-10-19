

/**
 * Copy and paste this code into your index.ios.js file.
 * Remember to update the app nape in the AppRegistry.
 * You will need a socket.io server running on port 3000.
 */


'use strict';

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback
} from 'react-native';

var SocketIO = require('react-native-socketio');

class SampleApp extends Component{

  constructor (props) {
    super(props);

    this.socket = new SocketIO('localhost:3000', {});
    this.state = { status: 'Not connected' };
  }

  componentDidMount () {

    this.socket.on('connect', () => {
      this.setState({
        status: 'Connected'
      });
    });

    this.socket.connect();
  }

  emitEvent () {
    this.socket.emit('randomEvent', {
      some: 'data'
    });
  }

  render () {
    return (
      <View style={styles.container}>

        <TouchableWithoutFeedback style={styles.btn} onPress={() => this.emitEvent()}>
          <View style={styles.btn}>
            <Text style={styles.btnText}>
              Emit an event
            </Text>
          </View>
        </TouchableWithoutFeedback>

        <Text style={styles.status}>
          Connection status: {this.state.status}
        </Text>

      </View>
    );
  }
};

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },

  btn: {
    backgroundColor: '#4F67FF',
    padding: 30,
    borderRadius: 5
  },

  btnText: {
    color: '#fff'
  }
});

AppRegistry.registerComponent('SampleApp', () => SampleApp);

if Meteor.isServer
  Meteor.startup ->
    # Generic method to iterate through a Meteor.server handler
    functionIsUnprotected = (func) ->
      return !(String(func).indexOf('void 0 : void 0) !== -1 || (userDoc != null ? (ref1 = userDoc.roles) != null ? ref1.indexOf("admin")') > -1)

    updateMethodAndInsertPermissionSnippet = (func, name, enabled, handler, endpoints, handlername) ->
      # Only proceed if the developer did not deactivate the checks for this handler
      if enabled && name.indexOf('/__dummy_coll_') == -1
        # Check if the endpoints is configured in the respective configuration
        if !endpoints.hasOwnProperty(name)
          # If it is not configured, throw an error and give the affected endpoint
          throw new Meteor.Error('Detected an issue with method permissions, please revise configuration of endpoint: ' + name)
        else
          # If it is configured, check the permission level of it
          newFunc = ->
            # If it is configured to not limit access the new endpoint is the same as the old one
            if endpoints[name] == 'none'
              func.apply this, arguments
            else
              # If it is configured to limit access the new endpoint we inject the permission snippet
              if handlername == "methods"
                userDoc = Meteor?.user()
              if handlername == "publications"
                userDoc = Meteor?.users.findOne(this.userId)
              if userDoc?.roles?.indexOf(endpoints[name]) != -1 or userDoc?.roles?.indexOf("admin") != -1
                func.apply this, arguments
              else
                # If the endpoint  gets invoked with wrong permissions, throw an Error 403
                throw new Meteor.Error('403 Not permitted')
          handler[name] = newFunc

    regularyCheckHandlerForPermissions = (handler, endpoints, enabled, handlername) ->
      # Iterate over all endpoints of the specified handler
      _.each handler, (func, name) ->
        updateMethodAndInsertPermissionSnippet func, name, enabled, handler, endpoints, handlername
      # If handler is valid
      if typeof handler == 'object' and handler != null
        # Use Object.observe polyfill to observe the handler for changes
        Object.observe handler, (changes) ->
          # Iterate over the changes array
          _.each changes, (change) ->
            # If the change is a valid function
            if typeof change.object[change?.name] == 'function' && functionIsUnprotected(change.object[change?.name])
              # Update the method and insert the permission snippet
              updateMethodAndInsertPermissionSnippet change.object[change?.name], change?.name, enabled, handler, endpoints, handlername

    # Check method handler
    regularyCheckHandlerForPermissions(Meteor.server.method_handlers, methodConfiguration.methods, methodConfiguration.enabled, 'methods')
    # Check publication handler
    regularyCheckHandlerForPermissions(Meteor.server.publish_handlers, publicationConfiguration.methods, publicationConfiguration.enabled, 'publications')
    0

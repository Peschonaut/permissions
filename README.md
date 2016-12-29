# permissions
The idea behind this package is to ensure a consistent, stress-free, centralized and transparent management of permissions within a Meteor project.

# Concept
When dealing with permissions there are many different ways to articulate sparate levels of access.

This package hooks the method_handlers and publish_handlers of the Meteor.server and modifies them to contain a predefined code snippet.
The included code snippet injects a compact check for the users permissions and comapares them to the permissions required by the method.
To determine the access level of a user we utilize the accounts-ui and accounts-password packages and read from the user.profile.roles (String).
To determine the required permissions for a method or publication we look up the method or publication in the config file that lies in your application's server directory.

There is also a variable for publications and methods respectively to enable/disable the permission control for development (publicationConfiguration.enabled and methodConfiguration.enabled).
If you do not want a method or publication to be restricted you can put a "none" as the required role and Meteor will not limit the access to it.

Example securify_config.js
```
publicationConfiguration = {
  "methods": {
    "meteor.loginServiceConfiguration":"none",
    "meteor_autoupdate_clientVersions":"none",
    "demo":"admin"
  },
  "enabled":true
};

methodConfiguration = {
  "methods": {
    "/users/insert":"none",
    "/users/update":"none",
    "/users/remove":"none",
    "login":"none",
    "logout":"none",
    "logoutOtherClients":"none",
    "getNewToken":"none",
    "removeOtherTokens":"none",
    "configureLoginService":"none",
    "changePassword":"none",
    "forgotPassword":"none",
    "resetPassword":"none",
    "verifyEmail":"none",
    "createUser":"none",
    "test":"management",
    "test2":"admin",
    "test3":"admin",
    "/meteor_accounts_loginServiceConfiguration/insert":"none",
    "/meteor_accounts_loginServiceConfiguration/update":"none",
    "/meteor_accounts_loginServiceConfiguration/remove":"none",
    "/demo/insert":"none",
    "/demo/update":"none",
    "/demo/remove":"none"
  },
  "enabled":true
};
```

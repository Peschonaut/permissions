Package.describe({
  name: 'laymi:permissions',
  version: '0.0.1',
  summary: 'The idea behind this package is to ensure a consistent, stress-free, centralized and transparent management of permissions within a Meteor project.',
  git: 'https://github.com/Laymi/permissions',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4.2.3');
  api.use('ecmascript');
  api.addFiles('object-observe.js');
  api.mainModule('permissions.js');
});

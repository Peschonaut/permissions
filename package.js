Package.describe({
  name: 'peschonaut:permissions',
  version: '0.0.1',
  summary: 'Stress-free, centralized, and transparent management of permissions within a Meteor project.',
  git: 'https://github.com/Peschonaut/permissions',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.5.1');
  api.use('ecmascript');
  api.addFiles('object-observe.js');
  api.mainModule('permissions.js');
});

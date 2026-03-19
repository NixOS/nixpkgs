let
  cocoapod-plugin = name: ''
    require "cocoapods"
    require "#{Gem::Specification.find_by_name(%(${name})).gem_dir}/lib/cocoapods_plugin"
  '';
in
{
  actioncable = [ "action_cable" ];
  actionmailer = [ "action_mailer" ];
  actionpack = [ "action_pack" ];
  actionview = [ "action_view" ];
  activejob = [ "active_job" ];
  activemodel = [ "active_model" ];
  activerecord = [ "active_record" ];
  activestorage = [ "active_storage" ];
  activesupport = [ "active_support" ];
  atk = [ "atk" ];
  CFPropertyList = [ "cfpropertylist" ];
  cocoapods-acknowledgements = [
    "cocoapods"
    "cocoapods_acknowledgements"
  ];
  cocoapods-art = [ "cocoapods_art" ];
  cocoapods-browser = [
    "cocoapods"
    "cocoapods_plugin"
  ];
  cocoapods-bugsnag = cocoapod-plugin "cocoapods-bugsnag";
  cocoapods-clean = [ "cocoapods_clean" ];
  cocoapods-coverage = [ "cocoapods_coverage" ];
  cocoapods-deintegrate = [ ]; # used by cocoapods
  cocoapods-dependencies = [ "cocoapods_dependencies" ];
  cocoapods-deploy = cocoapod-plugin "cocoapods-deploy";
  cocoapods-generate = cocoapod-plugin "cocoapods-generate";
  cocoapods-git_url_rewriter = cocoapod-plugin "cocoapods-git_url_rewriter";
  cocoapods-keys = [ ]; # osx only cocoapod-plugin "cocoapods-keys";
  cocoapods-open = [
    "cocoapods"
    "cocoapods_plugin"
  ];
  cocoapods-packager = [ "cocoapods_packager" ];
  cocoapods-packager-pro = [ ]; # requires osx
  cocoapods-plugins = [ "cocoapods_plugins" ];
  cocoapods-sorted-search = [ ]; # requires osx
  cocoapods-check = cocoapod-plugin "cocoapods-check";
  cocoapods-disable-podfile-validations = cocoapod-plugin "cocoapods-disable-podfile-validations";
  cocoapods-stats = [ "cocoapods_stats" ];
  cocoapods-testing = [ "cocoapods_testing" ];
  cocoapods-trunk = [ "cocoapods_trunk" ];
  cocoapods-try = [ "cocoapods_try" ];
  cocoapods-try-release-fix = cocoapod-plugin "cocoapods-try-release-fix";
  digest-sha3 = [ "digest/sha3" ];
  ffi-compiler = [ "ffi-compiler/loader" ];
  fog-core = [ "fog/core" ];
  fog-dnsimple = [ "fog/dnsimple" ];
  fog-json = [ "fog/json" ];
  forwardable-extended = [ "forwardable/extended" ];
  gdk_pixbuf2 = [ "gdk_pixbuf2" ];
  gitlab-markup = [ "github/markup" ];
  gobject-introspection = [ "gobject-introspection" ];
  gtk2 = [ ]; # requires display
  idn-ruby = [ "idn" ];
  jekyll-sass-converter = [ ]; # tested through jekyll
  libxml-ruby = [ "libxml" ];
  multipart-post = [ "multipart_post" ];
  unicode-display_width = [ "unicode/display_width" ];
  nap = [ "rest" ];
  net-scp = [ "net/scp" ];
  net-ssh = [ "net/ssh" ];
  nio4r = [ "nio" ];
  osx_keychain = [ ]; # requires osx
  ovirt-engine-sdk = [ "ovirtsdk4" ];
  pango = [ "pango" ];
  rack-test = [ "rack/test" ];
  railties = [ "rails" ];
  rspec-core = [ "rspec/core" ];
  rspec-expectations = [ "rspec/expectations" ];
  rspec-mocks = [ "rspec/mocks" ];
  rspec-support = [ "rspec/support" ];
  RubyInline = [ "inline" ];
  ruby-libvirt = [ "libvirt" ];
  ruby-lxc = [ "lxc" ];
  ruby-macho = [ "macho" ];
  ruby-terminfo = [ "terminfo" ];
  rubyzip = [ "zip" ];
  sequel_pg = [
    "pg"
    "sequel"
    "sequel/adapters/postgresql"
    "sequel_pg"
  ];
  simplecov-html = [ ]; # tested through simplecov
  sinatra = [ "sinatra/base" ];
  sprockets-rails = [ "sprockets/rails" ];
  taglib-ruby = [ "taglib" ];
  websocket-driver = [ "websocket/driver" ];
  websocket-extensions = [ "websocket/extensions" ];
  ZenTest = [ "zentest" ];
}

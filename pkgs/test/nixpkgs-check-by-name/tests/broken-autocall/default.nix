args:
builtins.removeAttrs
  (import <test-nixpkgs> { root = ./.; } args)
  [ "foo" ]

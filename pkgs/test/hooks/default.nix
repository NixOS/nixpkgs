# To run these tests:
# nix-build -A tests.hooks

{
  stdenv,
  tests,
  lib,
}:

{
  default-stdenv-hooks = lib.recurseIntoAttrs tests.stdenv.hooks;
}

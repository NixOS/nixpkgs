/*
Run with:
nix-build -E 'with import <nixpkgs> { }; callPackage ./test.nix {}' --show-trace; and cat result

Confusingly, the ideal result ends with something like:
error: build of ‘/nix/store/3245f3dcl2wxjs4rci7n069zjlz8qg85-test-results.tap.drv’ failed
*/
{ writeText, lib, callPackage, testFiles, stdenv, ruby }@defs:
let
  testTools = rec {
    test = import ./testing.nix;
    stubs = import ./stubs.nix defs;
    should = import ./assertions.nix { inherit test lib; };
  };

  tap = import ./tap-support.nix;

  results = builtins.concatLists (map (file: callPackage file testTools) testFiles);
in
  writeText "test-results.tap" (tap.output results)

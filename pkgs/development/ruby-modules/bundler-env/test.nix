/*
Run with:
nix-build -E 'with import <nixpkgs> { }; callPackage ./test.nix {}' --show-trace; and cat result

Confusingly, the ideal result ends with something like:
error: build of ‘/nix/store/3245f3dcl2wxjs4rci7n069zjlz8qg85-test-results.tap.drv’ failed
*/
{ writeText, lib, ruby, defaultGemConfig, callPackage }:
let
  test = import ./testing.nix;
  tap = import ./tap-support.nix;

  bundlerEnv = callPackage ./default.nix {};
  basicEnv = callPackage ./basic.nix {};

  testConfigs = {
    groups = ["default"];
    gemConfig =  defaultGemConfig;
    confFiles = "./testConfs";
  };
  functions = (import ./functions.nix ({ inherit lib ruby; } // testConfigs));

  should = {
    equal = expected: actual:
    if actual == expected then
    (test.passed "= ${toString expected}") else
    (test.failed "'${toString actual}'(${builtins.typeOf actual}) != '${toString expected}'(${builtins.typeOf expected})");

    beASet = actual:
    if builtins.isAttrs actual then
    (test.passed "is a set") else
    (test.failed "is not a set, was ${builtins.typeOf actual}: ${toString actual}");

    haveKeys = expected: actual:
    if builtins.all
      (ex: builtins.any (ac: ex == ac) (builtins.attrNames actual))
      expected then
      (test.passed "has expected keys") else
      (test.failed "keys differ: expected [${lib.concatStringsSep ";" expected}] have [${lib.concatStringsSep ";" (builtins.attrNames actual)}]");

    havePrefix = expected: actual:
    if lib.hasPrefix expected actual then
    (test.passed "has prefix '${expected}'") else
    (test.failed "prefix '${expected}' not found in '${actual}'");
  };

  justName = bundlerEnv {
    name = "test";
    gemset = ./test/gemset.nix;
  };

  pnamed = basicEnv {
    pname = "test";
    gemdir = ./test;
    gemset = ./test/gemset.nix;
    gemfile = ./test/Gemfile;
    lockfile = ./test/Gemfile.lock;
  };

  results = builtins.concatLists [
    (test.run "Filter empty gemset" {} (set: functions.filterGemset set == {}))
    (test.run "bundlerEnv { name }" justName {
      name = should.equal "test";
    })
    (test.run "bundlerEnv { pname }" pnamed
    [
      (should.haveKeys [ "name" "env" "postBuild" ])
      {
        name = should.equal "test-0.1.2";
        env = should.beASet;
        postBuild = should.havePrefix "nananana";
      }
    ])
  ];
in
  writeText "test-results.tap" (tap.output results)

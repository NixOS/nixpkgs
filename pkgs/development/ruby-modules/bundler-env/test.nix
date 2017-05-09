/*
Run with:
nix-build -E 'with import <nixpkgs> { }; callPackage ./test.nix {}' --show-trace; and cat result

Confusingly, the ideal result ends with something like:
error: build of ‘/nix/store/3245f3dcl2wxjs4rci7n069zjlz8qg85-test-results.tap.drv’ failed
*/
{ stdenv, writeText, lib, ruby, defaultGemConfig, callPackage }@defs:
let
  test = import ./testing.nix;
  tap = import ./tap-support.nix;
  stubs = import ./stubs.nix defs;
  should = import ./assertions.nix { inherit test lib; };

  basicEnv = callPackage ./basic.nix stubs;
  bundlerEnv = callPackage ./default.nix stubs // {
    inherit basicEnv;
  };

  testConfigs = {
    groups = ["default"];
    gemConfig =  defaultGemConfig;
    confFiles = "./testConfs";
  };
  functions = (import ./functions.nix ({ inherit lib; ruby = stubs.ruby; } // testConfigs));

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
        name = should.equal "test";
        env = should.beASet;
        postBuild = should.havePrefix "/nix/store";
      }
    ])
  ];
in
  writeText "test-results.tap" (tap.output results)

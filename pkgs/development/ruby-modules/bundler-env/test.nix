{ writeText, lib, ruby, defaultGemConfig, callPackage }:
let
  test = import ./testing.nix;
  tap = import ./tap-support.nix;

  bundlerEnv = callPackage ./default.nix {};

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
  };

  justName = bundlerEnv {
    name = "test";
    gemset = ./test/gemset.nix;
  };

  pnamed = bundlerEnv {
    pname = "test";
    gemset = ./test/gemset.nix;
  };

  results = builtins.concatLists [
    (test.run "Filter empty gemset" {} (set: functions.filterGemset set == {}))
    (test.run "bundlerEnv { name }" justName {
      name = should.equal "test";
    })
    (test.run "bundlerEnv { pname }" pnamed
     {
      name = should.equal "test-0.1.2";
      env = should.beASet;
    })
  ];
in
  writeText "test-results.tap" (tap.output results)

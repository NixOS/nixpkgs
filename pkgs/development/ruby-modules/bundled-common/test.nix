{ lib, ruby, defaultGemConfig, test, should }:
let
  testConfigs = {
    inherit lib;
    gemConfig =  defaultGemConfig;
  };
  functions = (import ./functions.nix testConfigs);
in
  builtins.concatLists [
    ( test.run "All set, no gemdir" (functions.bundlerFiles {
      gemfile  = test/Gemfile;
      lockfile = test/Gemfile.lock;
      gemset   = test/gemset.nix;
    }) {
      gemfile  = should.equal test/Gemfile;
      lockfile = should.equal test/Gemfile.lock;
      gemset   = should.equal test/gemset.nix;
    })

    ( test.run "Just gemdir" (functions.bundlerFiles {
      gemdir = test/.;
    }) {
      gemfile  = should.equal test/Gemfile;
      lockfile = should.equal test/Gemfile.lock;
      gemset   = should.equal test/gemset.nix;
    })

    ( test.run "Gemset and dir" (functions.bundlerFiles {
      gemdir = test/.;
      gemset = test/extraGemset.nix;
    }) {
      gemfile  = should.equal test/Gemfile;
      lockfile = should.equal test/Gemfile.lock;
      gemset   = should.equal test/extraGemset.nix;
    })

    ( test.run "Filter empty gemset" {} (set: functions.filterGemset {inherit ruby; groups = ["default"]; } set == {}))
    ( let gemSet = { test = { groups = ["x" "y"]; }; };
      in
      test.run "Filter matches a group" gemSet (set: functions.filterGemset {inherit ruby; groups = ["y" "z"];} set == gemSet))
    ( let gemSet = { test = { platforms = []; }; };
      in
      test.run "Filter matches empty platforms list" gemSet (set: functions.filterGemset {inherit ruby; groups = [];} set == gemSet))
    ( let gemSet = { test = { platforms = [{engine = ruby.rubyEngine; version = ruby.version.majMin;}]; }; };
      in
      test.run "Filter matches on platform" gemSet (set: functions.filterGemset {inherit ruby; groups = [];} set == gemSet))
    ( let gemSet = { test = { groups = ["x" "y"]; }; };
      in
      test.run "Filter excludes based on groups" gemSet (set: functions.filterGemset {inherit ruby; groups = ["a" "b"];} set == {}))
  ]

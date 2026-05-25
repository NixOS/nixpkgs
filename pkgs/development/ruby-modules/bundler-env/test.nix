{
  callPackage,
  test,
  stubs,
  should,
}:
let
  bundlerEnv = callPackage ./default.nix stubs // {
    basicEnv = callPackage ../bundled-common stubs;
  };

  justName = bundlerEnv {
    name = "test-0.1.2";
    gemset = ./test/gemset.nix;
  };

  pnamed = bundlerEnv {
    pname = "test";
    gemdir = ./test;
    gemset = ./test/gemset.nix;
    gemfile = ./test/Gemfile;
    lockfile = ./test/Gemfile.lock;
  };
in
builtins.concatLists [
  (test.run "bundlerEnv { name }" justName {
    name = should.equal "test-0.1.2";
  })
  (test.run "bundlerEnv { pname }" pnamed [
    (should.haveKeys [
      "name"
      "env"
      "postBuild"
    ])
    {
      name = should.equal "test-0.1.2";
      env = should.beASet;
      postBuild = should.havePrefix "/nix/store";
    }
  ])
]

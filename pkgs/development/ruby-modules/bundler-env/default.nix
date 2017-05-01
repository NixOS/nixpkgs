{ stdenv, runCommand, writeText, writeScript, writeScriptBin, ruby, lib
, callPackage, defaultGemConfig, fetchurl, fetchgit, buildRubyGem, buildEnv
, linkFarm
, git
, makeWrapper
, bundler
, tree
}@defs:

{ name ? null
, pname ? null
, gemdir ? null
, gemfile ? null
, lockfile ? null
, gemset ? null
, ruby ? defs.ruby
, gemConfig ? defaultGemConfig
, postBuild ? null
, document ? []
, meta ? {}
, groups ? ["default"]
, ignoreCollisions ? false
, ...
}@args:

let
  inherit (import ./functions.nix (defs // args)) genStubsScript;

  drvName =
    if name != null then name
    else if pname != null then "${toString pname}-${basicEnv.gems."${pname}".version}"
    else throw "bundlerEnv: either pname or name must be set";

  gemfile' =
    if gemfile == null then gemdir + "/Gemfile"
    else gemfile;

  lockfile' =
    if lockfile == null then gemdir + "/Gemfile.lock"
    else lockfile;

  gemset' =
    if gemset == null then gemdir + "/gemset.nix"
    else gemset;

  basicEnv = (callPackage ./basic.nix {}) (args // { inherit pname gemdir;
    gemfile = gemfile';
    lockfile  = lockfile';
    gemset = gemset';
  });

  inherit (basicEnv) envPaths;
  # Idea here is a mkDerivation that gen-bin-stubs new stubs "as specified" -
  # either specific executables or the bin/ for certain gem(s), but
  # incorporates the basicEnv as a requirement so that its $out is in our path.

  # When stubbing the bins for a gem, we should use the gem expression
  # directly, which means that basicEnv should somehow make it available.

  # Different use cases should use different variations on this file, rather
  # than the expression trying to deduce a use case.

  # The basicEnv should be put into passthru so that e.g. nix-shell can use it.
in
  if builtins.trace "pname: ${toString pname}" pname == null then
    basicEnv // { inherit name; }
  else
    (buildEnv {
      inherit ignoreCollisions;

      name = builtins.trace "name: ${toString drvName}" drvName;

      paths = envPaths;
      pathsToLink = [ "/lib" ];

      postBuild = genStubsScript defs // args // {
        inherit bundler;
        confFiles = basicEnv.confFiles;
        binPaths = [ basicEnv.mainGem ];
      } + lib.optionalString (postBuild != null) postBuild;

      meta = { platforms = ruby.meta.platforms; } // meta;
      passthru = basicEnv.passthru // {
        inherit basicEnv;
        inherit (basicEnv) env;
      };
    })

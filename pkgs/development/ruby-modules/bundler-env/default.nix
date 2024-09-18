{ ruby, lib, callPackage, defaultGemConfig, buildEnv, runCommand
, buildPackages
, bundler
}@defs:

{ name ? null
, pname ? null
, gemdir ? null
, gemfile ? null
, lockfile ? null
, gemset ? null
, groups ? ["default"]
, ruby ? defs.ruby
, copyGemFiles ? false # Copy gem files instead of symlinking
, gemConfig ? defaultGemConfig
, postBuild ? null
, document ? []
, meta ? {}
, ignoreCollisions ? false
, passthru ? {}
, ...
}@args:

let
  inherit (import ../bundled-common/functions.nix { inherit lib ruby gemConfig groups; }) genStubsScript;

  basicEnv = (callPackage ../bundled-common { inherit bundler; }) (args // { inherit pname name; mainGemName = pname; });

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
  if pname == null then
    basicEnv // { inherit name basicEnv; }
  else
    let
      bundlerEnvArgs = {
        inherit ignoreCollisions;

        name = basicEnv.name;

        paths = envPaths;
        pathsToLink = [ "/lib" ];

        postBuild = genStubsScript {
          inherit lib runCommand ruby bundler groups;
          confFiles = basicEnv.confFiles;
          binPaths = [ basicEnv.gems.${pname} ];
        } + lib.optionalString (postBuild != null) postBuild;

        meta = { platforms = ruby.meta.platforms; } // meta;
        passthru = basicEnv.passthru // {
          inherit basicEnv;
          inherit (basicEnv) env;
        } // passthru;
      };
    in
      if copyGemFiles then
        runCommand basicEnv.name bundlerEnvArgs ''
          mkdir -p $out
          for i in $paths; do
            ${buildPackages.rsync}/bin/rsync -a $i/lib $out/
          done
          eval "$postBuild"
        ''
      else
        buildEnv bundlerEnvArgs

{ stdenv, runCommand, ruby, lib, rsync
, defaultGemConfig, buildRubyGem, buildEnv
, makeBinaryWrapper
, bundler
}@defs:

{
  name ? null
, pname ? null
, mainGemName ? null
, gemdir ? null
, gemfile ? null
, lockfile ? null
, gemset ? null
, ruby ? defs.ruby
, copyGemFiles ? false # Copy gem files instead of symlinking
, gemConfig ? defaultGemConfig
, postBuild ? null
, document ? []
, meta ? {}
, groups ? null
, ignoreCollisions ? false
, nativeBuildInputs ? []
, buildInputs ? []
, extraConfigPaths ? []
, passthru ? {}
, ...
}@args:

assert name == null -> pname != null;

let
  functions = import ./functions.nix { inherit lib gemConfig; };

  inherit (functions)
    applyGemConfigs
    bundlerFiles
    composeGemAttrs
    filterGemset
    genStubsScript
    pathDerivation
    ;

  gemFiles = bundlerFiles args;

  importedGemset = if builtins.typeOf gemFiles.gemset != "set"
    then import gemFiles.gemset
    else gemFiles.gemset;

  filteredGemset = filterGemset { inherit ruby groups; } importedGemset;

  configuredGemset = lib.flip lib.mapAttrs filteredGemset (name: attrs:
    applyGemConfigs (attrs // { inherit ruby document; gemName = name; })
  );

  hasBundler = builtins.hasAttr "bundler" filteredGemset;

  bundler =
    if hasBundler then gems.bundler
    else defs.bundler.override (attrs: { inherit ruby; });

  gems = lib.flip lib.mapAttrs configuredGemset (name: attrs: buildGem name attrs);

  name' = if name != null then
    name
  else
    let
      gem = gems.${pname};
      suffix = gem.suffix;
    in
      "${pname}-${suffix}";

  pname' = if pname != null then
    pname
  else
    name;

  copyIfBundledByPath = { bundledByPath ? false, ...}:
  (lib.optionalString bundledByPath (
      assert gemFiles.gemdir != null; "cp -a ${gemFiles.gemdir}/* $out/") #*/
  );

  maybeCopyAll = pkgname: lib.optionalString (pkgname != null) (
    let
      mainGem = gems.${pkgname} or (throw "bundlerEnv: gem ${pkgname} not found");
    in
      copyIfBundledByPath mainGem
  );

  # We have to normalize the Gemfile.lock, otherwise bundler tries to be
  # helpful by doing so at run time, causing executables to immediately bail
  # out. Yes, I'm serious.
  confFiles = runCommand "gemfile-and-lockfile" {} ''
    mkdir -p $out
    ${maybeCopyAll mainGemName}
    cp ${gemFiles.gemfile} $out/Gemfile || ls -l $out/Gemfile
    cp ${gemFiles.lockfile} $out/Gemfile.lock || ls -l $out/Gemfile.lock

    ${lib.concatMapStringsSep "\n" (path: "cp -r ${path} $out/") extraConfigPaths}
  '';

  buildGem = name: attrs: (
    let
      gemAttrs = composeGemAttrs ruby gems name attrs;
    in
    if gemAttrs.type == "path" then
      pathDerivation (gemAttrs.source // gemAttrs)
    else
      buildRubyGem gemAttrs
  );

  envPaths = lib.attrValues gems ++ lib.optional (!hasBundler) bundler;


  basicEnvArgs = {
    inherit nativeBuildInputs buildInputs ignoreCollisions;

    name = name';

    paths = envPaths;
    pathsToLink = [ "/lib" ];

    postBuild = genStubsScript (defs // args // {
      inherit confFiles bundler groups;
      binPaths = envPaths;
    }) + lib.optionalString (postBuild != null) postBuild;

    meta = { platforms = ruby.meta.platforms; } // meta;

    passthru = (lib.optionalAttrs (pname != null) {
      inherit (gems.${pname}) gemType;
    } // rec {
      inherit ruby bundler gems confFiles envPaths;

      wrappedRuby = stdenv.mkDerivation {
        name = "wrapped-ruby-${pname'}";

        nativeBuildInputs = [ makeBinaryWrapper ];

        dontUnpack = true;

        buildPhase = ''
          mkdir -p $out/bin
          for i in ${ruby}/bin/*; do
            makeWrapper "$i" $out/bin/$(basename "$i") \
              --set BUNDLE_GEMFILE ${confFiles}/Gemfile \
              --unset BUNDLE_PATH \
              --set BUNDLE_FROZEN 1 \
              --set GEM_HOME ${basicEnv}/${ruby.gemPath} \
              --set GEM_PATH ${basicEnv}/${ruby.gemPath}
          done
        '';

        dontInstall = true;

        doCheck = true;
        checkPhase = ''
          $out/bin/ruby --help > /dev/null
        '';

        inherit (ruby) meta;
      };

      env = let
        irbrc = builtins.toFile "irbrc" ''
          if !(ENV["OLD_IRBRC"].nil? || ENV["OLD_IRBRC"].empty?)
            require ENV["OLD_IRBRC"]
          end
          require 'rubygems'
          require 'bundler/setup'
        '';
        in stdenv.mkDerivation {
          name = "${pname'}-interactive-environment";
          nativeBuildInputs = [ wrappedRuby basicEnv ];
          shellHook = ''
            export OLD_IRBRC=$IRBRC
            export IRBRC=${irbrc}
          '';
          buildCommand = ''
            echo >&2 ""
            echo >&2 "*** Ruby 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
            echo >&2 ""
            exit 1
          '';
        };
    } // passthru);
  };

  basicEnv =
    if copyGemFiles then
      runCommand name' basicEnvArgs ''
        mkdir -p $out
        for i in $paths; do
          ${rsync}/bin/rsync -a $i/lib $out/
        done
        eval "$postBuild"
      ''
    else
      buildEnv basicEnvArgs;
in
  basicEnv

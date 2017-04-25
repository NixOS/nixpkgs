{ stdenv, runCommand, ruby, lib
, defaultGemConfig, buildRubyGem, buildEnv
, makeWrapper
, bundler
}@defs:

{
  drvName
, pname
, gemfile
, lockfile
, gemset
, ruby ? defs.ruby
, gemConfig ? defaultGemConfig
, postBuild ? null
, document ? []
, meta ? {}
, groups ? ["default"]
, ignoreCollisions ? false
, ...
}@args:

with (import ./functions.nix);

let
  mainGem = gems."${pname}" or (throw "bundlerEnv: gem ${pname} not found");

  importedGemset = import gemset;

  filteredGemset = lib.filterAttrs (name: attrs: platformMatches attrs && groupMatches attrs) importedGemset;

  configuredGemset = lib.flip lib.mapAttrs filteredGemset (name: attrs:
    applyGemConfigs (attrs // { inherit ruby; gemName = name; })
  );

  hasBundler = builtins.hasAttr "bundler" filteredGemset;

  bundler =
    if hasBundler then gems.bundler
    else defs.bundler.override (attrs: { inherit ruby; });

  gems = lib.flip lib.mapAttrs configuredGemset (name: attrs: buildGem name attrs);

  copyIfBundledByPath = { bundledByPath ? false, ...}@main:
  (if bundledByPath then ''
  cp -a ${gemdir}/* $out/
  '' else ""
  );

  maybeCopyAll = main: if main == null then "" else copyIfBundledByPath main;

  # We have to normalize the Gemfile.lock, otherwise bundler tries to be
  # helpful by doing so at run time, causing executables to immediately bail
  # out. Yes, I'm serious.
  confFiles = runCommand "gemfile-and-lockfile" {} ''
    mkdir -p $out
    ${maybeCopyAll mainGem}
    cp ${gemfile} $out/Gemfile || ls -l $out/Gemfile
    cp ${lockfile} $out/Gemfile.lock || ls -l $out/Gemfile.lock
  '';

  buildGem = name: attrs: (
    let
      gemAttrs = composeGemAttrs gems name attrs;
    in
    if gemAttrs.type == "path" then
      pathDerivation gemAttrs
    else
      buildRubyGem gemAttrs
  );

  envPaths = lib.attrValues gems ++ lib.optional (!hasBundler) bundler;

  # binPaths = if mainGem != null then [ mainGem ] else envPaths;

in
  buildEnv {
    inherit ignoreCollisions;

    name = drvName;

    paths = envPaths;
    pathsToLink = [ "/lib" ];

    postBuild = genStubsScript defs // args // {
      inherit confFiles bundler;
      binPaths = envPaths;
    } + lib.optionalString (postBuild != null) postBuild;

    meta = { platforms = ruby.meta.platforms; } // meta;

    passthru = rec {
      inherit ruby bundler gems;

      wrappedRuby = stdenv.mkDerivation {
        name = "wrapped-ruby-${drvName}";
        nativeBuildInputs = [ makeWrapper ];
        buildCommand = ''
          mkdir -p $out/bin
          for i in ${ruby}/bin/*; do
            makeWrapper "$i" $out/bin/$(basename "$i") \
              --set BUNDLE_GEMFILE ${confFiles}/Gemfile \
              --set BUNDLE_PATH ${bundlerEnv}/${ruby.gemPath} \
              --set BUNDLE_FROZEN 1 \
              --set GEM_HOME ${bundlerEnv}/${ruby.gemPath} \
              --set GEM_PATH ${bundlerEnv}/${ruby.gemPath}
          done
        '';
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
          name = "${drvName}-interactive-environment";
          nativeBuildInputs = [ wrappedRuby bundlerEnv ];
          shellHook = ''
            export OLD_IRBRC="$IRBRC"
            export IRBRC=${irbrc}
          '';
          buildCommand = ''
            echo >&2 ""
            echo >&2 "*** Ruby 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
            echo >&2 ""
            exit 1
          '';
        };
    };
  }

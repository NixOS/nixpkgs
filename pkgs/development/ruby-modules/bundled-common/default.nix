{ stdenv, runCommand, ruby, lib
, defaultGemConfig, buildRubyGem, buildEnv
, makeWrapper
, bundler
}@defs:

{
  name
, pname ? name
, gemdir
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

with  import ./functions.nix { inherit lib gemConfig; };

let

  importedGemset = import gemset;

  filteredGemset = filterGemset { inherit ruby groups; } importedGemset;

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

  maybeCopyAll = pname: if pname == null then "" else
  let
    mainGem = gems."${pname}" or (throw "bundlerEnv: gem ${pname} not found");
  in
    copyIfBundledByPath mainGem;

  # We have to normalize the Gemfile.lock, otherwise bundler tries to be
  # helpful by doing so at run time, causing executables to immediately bail
  # out. Yes, I'm serious.
  confFiles = runCommand "gemfile-and-lockfile" {} ''
    mkdir -p $out
    ${maybeCopyAll pname}
    cp ${gemfile} $out/Gemfile || ls -l $out/Gemfile
    cp ${lockfile} $out/Gemfile.lock || ls -l $out/Gemfile.lock
  '';

  buildGem = name: attrs: (
    let
      gemAttrs = composeGemAttrs ruby gems name attrs;
    in
    if gemAttrs.type == "path" then
      pathDerivation gemAttrs
    else
      buildRubyGem gemAttrs
  );

  envPaths = lib.attrValues gems ++ lib.optional (!hasBundler) bundler;

  basicEnv = buildEnv {
    inherit ignoreCollisions;

    name = if name == null then pname else name;

    #name = pname;

    paths = envPaths;
    pathsToLink = [ "/lib" ];

    postBuild = genStubsScript (defs // args // {
      inherit confFiles bundler groups;
      binPaths = envPaths;
    }) + lib.optionalString (postBuild != null) postBuild;

    meta = { platforms = ruby.meta.platforms; } // meta;

    passthru = rec {
      inherit ruby bundler gems mainGem confFiles envPaths;

      wrappedRuby =
      stdenv.mkDerivation {
        name = "wrapped-ruby-${pname}";
        nativeBuildInputs = [ makeWrapper ];
        buildCommand = ''
          mkdir -p $out/bin
          for i in ${ruby}/bin/*; do
            makeWrapper "$i" $out/bin/$(basename "$i") \
              --set BUNDLE_GEMFILE ${confFiles}/Gemfile \
              --set BUNDLE_PATH ${basicEnv}/${ruby.gemPath} \
              --set BUNDLE_FROZEN 1 \
              --set GEM_HOME ${basicEnv}/${ruby.gemPath} \
              --set GEM_PATH ${basicEnv}/${ruby.gemPath}
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
          name = "${pname}-interactive-environment";
          nativeBuildInputs = [ wrappedRuby basicEnv ];
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
  };
in
  basicEnv

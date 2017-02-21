{ stdenv, runCommand, writeText, writeScript, writeScriptBin, ruby, lib
, callPackage, defaultGemConfig, fetchurl, fetchgit, buildRubyGem, buildEnv
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
  drvName =
    if name != null then name
    else if pname != null then "${toString pname}-${mainGem.version}"
    else throw "bundlerEnv: either pname or name must be set";

  mainGem =
    if pname == null then null
    else gems."${pname}" or (throw "bundlerEnv: gem ${pname} not found");

  gemfile' =
    if gemfile == null then gemdir + "/Gemfile"
    else gemfile;

  lockfile' =
    if lockfile == null then gemdir + "/Gemfile.lock"
    else lockfile;

  gemset' =
    if gemset == null then gemdir + "/gemset.nix"
    else gemset;

  importedGemset = import gemset';

  platformMatches = attrs: (
  !(attrs ? "platforms") ||
    builtins.any (platform:
      platform.engine == ruby.rubyEngine &&
        (!(platform ? "version") || platform.version == ruby.version.majMin)
    ) attrs.platforms
  );

  groupMatches = attrs: (
  !(attrs ? "groups") ||
    builtins.any (gemGroup: builtins.any (group: group == gemGroup) groups) attrs.groups
  );

  filteredGemset = lib.filterAttrs (name: attrs: platformMatches attrs && groupMatches attrs) importedGemset;

  applyGemConfigs = attrs:
    (if gemConfig ? "${attrs.gemName}"
    then attrs // gemConfig."${attrs.gemName}" attrs
    else attrs);

  configuredGemset = lib.flip lib.mapAttrs filteredGemset (name: attrs:
    applyGemConfigs (attrs // { inherit ruby; gemName = name; })
  );

  hasBundler = builtins.hasAttr "bundler" filteredGemset;

  bundler =
    if hasBundler then gems.bundler
    else defs.bundler.override (attrs: { inherit ruby; });

  pathDerivation = { gemName, version, path, ...  }:
    let
      res = {
          type = "derivation";
          bundledByPath = true;
          name = gemName;
          version = version;
          outPath = path;
          outputs = [ "out" ];
          out = res;
          outputName = "out";
        };
    in res;

  buildGem = name: attrs: (
    let
      gemAttrs = ((removeAttrs attrs ["source"]) // attrs.source // {
        inherit ruby;
        gemName = name;
        gemPath = map (gemName: gems."${gemName}") (attrs.dependencies or []);
      });
    in
    if gemAttrs.type == "path" then pathDerivation gemAttrs
    else buildRubyGem gemAttrs);

  gems = lib.flip lib.mapAttrs configuredGemset (name: attrs: buildGem name attrs);

  maybeCopyAll = main: if main == null then "" else copyIfBundledByPath main;

  copyIfBundledByPath = { bundledByPath ? false, ...}@main:
  (if bundledByPath then ''
  cp -a ${gemdir}/* $out/
  '' else ""
  );

  # We have to normalize the Gemfile.lock, otherwise bundler tries to be
  # helpful by doing so at run time, causing executables to immediately bail
  # out. Yes, I'm serious.
  confFiles = runCommand "gemfile-and-lockfile" {} ''
    mkdir -p $out
    ${maybeCopyAll mainGem}
    cp ${gemfile'} $out/Gemfile || ls -l $out/Gemfile
    cp ${lockfile'} $out/Gemfile.lock || ls -l $out/Gemfile.lock
  '';

  envPaths = lib.attrValues gems ++ lib.optional (!hasBundler) bundler;

  binPaths = if mainGem != null then [ mainGem ] ++ envPaths else envPaths;

  bundlerEnv = buildEnv {
    inherit ignoreCollisions;

    name = drvName;

    paths = envPaths;
    pathsToLink = [ "/lib" ];

    postBuild = ''
      ${ruby}/bin/ruby ${./gen-bin-stubs.rb} \
        "${ruby}/bin/ruby" \
        "${confFiles}/Gemfile" \
        "$out/${ruby.gemPath}" \
        "${bundler}/${ruby.gemPath}" \
        ${lib.escapeShellArg binPaths} \
        ${lib.escapeShellArg groups}
    '' + lib.optionalString (postBuild != null) postBuild;

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
          name = "interactive-${drvName}-environment";
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
  };
in
  bundlerEnv

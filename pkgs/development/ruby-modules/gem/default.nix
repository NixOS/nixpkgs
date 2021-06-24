# This builds gems in a way that is compatible with bundler.
#
# Bundler installs gems from git sources _very_ differently from how RubyGems
# installes gem packages, though they both install gem packages similarly.
#
# We monkey-patch Bundler to remove any impurities and then drive its internals
# to install git gems.
#
# For the sake of simplicity, gem packages are installed with the standard `gem`
# program.
#
# Note that bundler does not support multiple prefixes; it assumes that all
# gems are installed in a common prefix, and has no support for specifying
# otherwise. Therefore, if you want to be able to use the resulting derivations
# with bundler, you need to create a symlink forrest first, which is what
# `bundlerEnv` does for you.
#
# Normal gem packages can be used outside of bundler; a binstub is created in
# $out/bin.

{ lib, fetchurl, fetchgit, makeWrapper, gitMinimal, darwin
, ruby, bundler
} @ defs:

lib.makeOverridable (

{ name ? null
, gemName
, version ? null
, type ? "gem"
, document ? [] # e.g. [ "ri" "rdoc" ]
, platform ? "ruby"
, ruby ? defs.ruby
, stdenv ? ruby.stdenv
, namePrefix ? (let
    rubyName = builtins.parseDrvName ruby.name;
  in "${rubyName.name}${rubyName.version}-")
, buildInputs ? []
, meta ? {}
, patches ? []
, gemPath ? []
, dontStrip ? false
# Assume we don't have to build unless strictly necessary (e.g. the source is a
# git checkout).
# If you need to apply patches, make sure to set `dontBuild = false`;
, dontBuild ? true
, dontInstallManpages ? false
, propagatedBuildInputs ? []
, propagatedUserEnvPkgs ? []
, buildFlags ? []
, passthru ? {}
# bundler expects gems to be stored in the cache directory for certain actions
# such as `bundler install --redownload`.
# At the cost of increasing the store size, you can keep the gems to have closer
# alignment with what Bundler expects.
, keepGemCache ? false
, ...} @ attrs:

let
  src = attrs.src or (
    if type == "gem" then
      fetchurl {
        urls = map (
          remote: "${remote}/gems/${gemName}-${version}.gem"
        ) (attrs.source.remotes or [ "https://rubygems.org" ]);
        inherit (attrs.source) sha256;
      }
    else if type == "git" then
      fetchgit {
        inherit (attrs.source) url rev sha256 fetchSubmodules;
      }
    else if type == "url" then
      fetchurl attrs.source
    else
      throw "buildRubyGem: don't know how to build a gem of type \"${type}\""
  );
  documentFlag =
    if document == []
    then "-N"
    else "--document ${lib.concatStringsSep "," document}";

in

stdenv.mkDerivation ((builtins.removeAttrs attrs ["source"]) // {
  inherit ruby;
  inherit dontBuild;
  inherit dontStrip;
  inherit type;

  buildInputs = [
    ruby makeWrapper
  ] ++ lib.optionals (type == "git") [ gitMinimal ]
    ++ lib.optionals (type != "gem") [ bundler ]
    ++ lib.optional stdenv.isDarwin darwin.libobjc
    ++ buildInputs;

  #name = builtins.trace (attrs.name or "no attr.name" ) "${namePrefix}${gemName}-${version}";
  name = attrs.name or "${namePrefix}${gemName}-${version}";

  inherit src;


  unpackPhase = attrs.unpackPhase or ''
    runHook preUnpack

    if [[ -f $src && $src == *.gem ]]; then
      if [[ -z "''${dontBuild-}" ]]; then
        # we won't know the name of the directory that RubyGems creates,
        # so we'll just use a glob to find it and move it over.
        gempkg="$src"
        sourceRoot=source
        gem unpack $gempkg --target=container
        cp -r container/* $sourceRoot
        rm -r container

        # copy out the original gemspec, for convenience during patching /
        # overrides.
        gem specification $gempkg  --ruby > original.gemspec
        gemspec=$(readlink -f .)/original.gemspec
      else
        gempkg="$src"
      fi
    else
      # Fall back to the original thing for everything else.
      dontBuild=""
      preUnpack="" postUnpack="" unpackPhase
    fi

    runHook postUnpack
  '';

  # As of ruby 3.0, ruby headers require -fdeclspec when building with clang
  # Introduced in https://github.com/ruby/ruby/commit/0958e19ffb047781fe1506760c7cbd8d7fe74e57
  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.cc.isClang && lib.versionAtLeast ruby.version.major "3") [
    "-fdeclspec"
  ];

  buildPhase = attrs.buildPhase or ''
    runHook preBuild

    if [[ "$type" == "gem" ]]; then
      if [[ -z "$gemspec" ]]; then
        gemspec="$(find . -name '*.gemspec')"
        echo "found the following gemspecs:"
        echo "$gemspec"
        gemspec="$(echo "$gemspec" | head -n1)"
      fi

      exec 3>&1
      output="$(gem build $gemspec | tee >(cat - >&3))"
      exec 3>&-

      gempkg=$(echo "$output" | grep -oP 'File: \K(.*)')

      echo "gem package built: $gempkg"
    elif [[ "$type" == "git" ]]; then
      git init
      # remove variations to improve the likelihood of a bit-reproducible output
      rm -rf .git/logs/ .git/hooks/ .git/index .git/FETCH_HEAD .git/ORIG_HEAD .git/refs/remotes/origin/HEAD .git/config
      # support `git ls-files`
      git add .
    fi

    runHook postBuild
  '';

  # Note:
  #   We really do need to keep the $out/${ruby.gemPath}/cache.
  #   This is very important in order for many parts of RubyGems/Bundler to not blow up.
  #   See https://github.com/bundler/bundler/issues/3327
  installPhase = attrs.installPhase or ''
    runHook preInstall

    export GEM_HOME=$out/${ruby.gemPath}
    mkdir -p $GEM_HOME

    echo "buildFlags: $buildFlags"

    ${lib.optionalString (type ==  "url") ''
    ruby ${./nix-bundle-install.rb} \
      "path" \
      '${gemName}' \
      '${version}' \
      '${lib.escapeShellArgs buildFlags}'
    ''}
    ${lib.optionalString (type == "git") ''
    ruby ${./nix-bundle-install.rb} \
      "git" \
      '${gemName}' \
      '${version}' \
      '${lib.escapeShellArgs buildFlags}' \
      '${attrs.source.url}' \
      '.' \
      '${attrs.source.rev}'
    ''}

    ${lib.optionalString (type == "gem") ''
    if [[ -z "$gempkg" ]]; then
      echo "failure: \$gempkg path unspecified" 1>&2
      exit 1
    elif [[ ! -f "$gempkg" ]]; then
      echo "failure: \$gempkg path invalid" 1>&2
      exit 1
    fi

    gem install \
      --local \
      --force \
      --http-proxy 'http://nodtd.invalid' \
      --ignore-dependencies \
      --install-dir "$GEM_HOME" \
      --build-root '/' \
      --backtrace \
      --no-env-shebang \
      ${documentFlag} \
      $gempkg $gemFlags -- $buildFlags

    # looks like useless files which break build repeatability and consume space
    pushd $out/${ruby.gemPath}
    rm -fv doc/*/*/created.rid || true
    rm -fv {gems/*/ext/*,extensions/*/*/*}/{Makefile,mkmf.log,gem_make.out} || true
    ${if keepGemCache then "" else "rm -fvr cache"}
    popd

    # write out metadata and binstubs
    spec=$(echo $out/${ruby.gemPath}/specifications/*.gemspec)
    ruby ${./gem-post-build.rb} "$spec"
    ''}

    ${lib.optionalString (!dontInstallManpages) ''
    for section in {1..9}; do
      mandir="$out/share/man/man$section"
      find $out/lib \( -wholename "*/man/*.$section" -o -wholename "*/man/man$section/*.$section" \) \
        -execdir mkdir -p $mandir \; -execdir cp '{}' $mandir \;
    done
    ''}

    runHook postInstall
  '';

  propagatedBuildInputs = gemPath ++ propagatedBuildInputs;
  propagatedUserEnvPkgs = gemPath ++ propagatedUserEnvPkgs;

  passthru = passthru // { isRubyGem = true; };
  inherit meta;
})

)

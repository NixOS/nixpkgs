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

{ lib, fetchurl, fetchgit, makeWrapper, git, darwin
, ruby, bundler, defaultGemConfig
} @ defs:

let
  toArgs = x:
    if x == null then ""
    else toString (map lib.escapeShellArg x);
in

# Assume we don't have to build unless strictly necessary (e.g. the source is a
# git checkout).
# If you need to apply patches, make sure to set `dontBuild = false`;
{ gemName
, buildFlags ? []
, buildInputs ? []
, doCheck ? false
, document ? [] # e.g. [ "ri" "rdoc" ]
, dontBuild ? true
, dontStrip ? true
, gemConfig ? defs.defaultGemConfig
, gemPath ? []
, meta ? {}
, passthru ? {}
, patches ? []
, platform ? "ruby"
, propagatedBuildInputs ? []
, propagatedUserEnvPkgs ? []
, remotes ? ["https://rubygems.org"]
, ruby ? defs.ruby
, stdenv ? ruby.stdenv
, type ? "gem"
, version ? null
, ...} @ attrs:

let
  applyGemConfig = attrs:
    if gemConfig ? "${gemName}" then
      attrs // gemConfig."${gemName}" attrs
    else
      attrs;
  name = attrs.name or (
    let
      x = builtins.parseDrvName ruby.name;
    in
      "${x.name}${x.version}-${gemName}-${version}"
  );
  src = attrs.src or (
    if type == "gem" then
      fetchurl {
        urls = map (remote: "${remote}/gems/${gemName}-${version}.gem") remotes;
        inherit (attrs) sha256;
      }
    else if type == "git" then
      fetchgit {
        inherit (attrs) url rev sha256 fetchSubmodules;
        leaveDotGit = true;
      }
    else
      throw "buildRubyGem: don't know how to build a gem of type \"${type}\""
  );
  documentFlag =
    if document == []
    then "-N"
    else "--document ${lib.concatStringsSep "," document}";

  attrs_ = applyGemConfig (attrs // {
    inherit
      buildFlags
      buildInputs
      doCheck
      document
      dontBuild
      dontStrip
      gemName
      gemPath
      meta
      name
      passthru
      patches
      platform
      propagatedBuildInputs
      propagatedUserEnvPkgs
      remotes
      ruby
      stdenv
      src
      type
      version
      ;
  });
in

let
  attrs = attrs_;
in

stdenv.mkDerivation (attrs // {
  buildInputs = [
    ruby makeWrapper
  ] ++ lib.optionals (type == "git") [ git bundler ]
    ++ lib.optional stdenv.isDarwin darwin.libobjc
    ++ attrs.buildInputs;

  phases = attrs.phases or [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" "fixupPhase" ];

  unpackPhase = attrs.unpackPhase or ''
    runHook preUnpack

    if [[ -f $src && $src == *.gem ]]; then
      if [[ -z "$dontBuild" ]]; then
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

    ${lib.optionalString (type == "git") ''
    ruby ${./nix-bundle-install.rb} \
      ${gemName} \
      ${attrs.url} \
      ${src} \
      ${attrs.rev} \
      ${version} \
      ${toArgs attrs.buildFlags}
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
      --build-root '/' \
      --backtrace \
      ${documentFlag} \
      $gempkg $gemFlags -- $buildFlags

    # looks like useless files which break build repeatability and consume space
    rm -fv $out/${ruby.gemPath}/doc/*/*/created.rid || true
    rm -fv $out/${ruby.gemPath}/gems/*/ext/*/mkmf.log || true

    # write out metadata and binstubs
    spec=$(echo $out/${ruby.gemPath}/specifications/*.gemspec)
    ruby ${./gem-post-build.rb} "$spec"
    ''}

    runHook postInstall
  '';

  propagatedBuildInputs = gemPath ++ attrs.propagatedBuildInputs;
  propagatedUserEnvPkgs = gemPath ++ attrs.propagatedUserEnvPkgs;

  passthru = attrs.passthru // { isRubyGem = true; };
})

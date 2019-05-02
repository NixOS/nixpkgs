{ nodejs-slim, mkYarnPackage, fetchFromGitHub, bundlerEnv,
  stdenv, yarn, ... }:

let
  version = "v2.8.0";
  tmpDir = "/tmp/mastodon";
  logDir = "/var/log/mastodon";

  src = stdenv.mkDerivation {
    name = "mastodon-src";
    src = fetchFromGitHub {
      owner = "tootsuite";
      repo = "mastodon";
      rev = "6afab2587de40d403e64724f6ae688b180de25d4";
      sha256 = "12nb687ly11di6l508cf9719mqk89iggngj80dvmpy1qzdib5nd4";
    };
    patches = [ ./mastodon-nix.patch ];
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };

  mastodon-gems = bundlerEnv {
    name = "mastodon-gems";
    inherit version;
    gemdir = src;
    gemset = ./gemset.nix;
  };

  mastodon-js-modules = mkYarnPackage {
    name = "mastodon-modules";
    yarnNix = ./yarn.nix;
    inherit src;
  };

  mastodon-assets = stdenv.mkDerivation {
    name = "mastodon-assets";
    inherit src version;

    buildInputs = [
      mastodon-gems nodejs-slim yarn
    ];

    buildPhase = ''
      cp -r "${mastodon-js-modules}/libexec/mastodon/node_modules" "node_modules"
      chmod -R u+w node_modules
      rake assets:precompile
    '';

    installPhase = ''
      mkdir -p $out/public
      cp -r public/assets $out/public
      cp -r public/packs $out/public
    '';
  };

in stdenv.mkDerivation {
  name = "mastodon";
  inherit src version;

  buildPhase = ''
    ln -s ${mastodon-js-modules}/libexec/mastodon/node_modules node_modules
    ln -s ${mastodon-assets}/public/assets public/assets
    ln -s ${mastodon-assets}/public/packs public/packs

    for b in $(ls ${mastodon-gems}/bin/)
    do
      rm -f bin/$b
      ln -s ${mastodon-gems}/bin/$b bin/$b
    done

    rm -rf log
    ln -s ${logDir} log
    ln -s ${tmpDir} tmp
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}

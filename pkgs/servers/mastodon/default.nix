{ nodejs-slim, mkYarnPackage, fetchFromGitHub, bundlerEnv,
  stdenv, yarn, callPackage, imagemagick, ffmpeg, file, ... }:

let
  version = import ./version.nix;
  src = callPackage ./source-patched.nix {};

  mastodon-gems = bundlerEnv {
    name = "mastodon-gems-${version}";
    inherit version;
    gemdir = src;
    gemset = ./gemset.nix;
  };

  mastodon-js-modules = mkYarnPackage {
    pname = "mastodon-modules";
    yarnNix = ./yarn.nix;
    packageJSON = ./package.json;
    inherit src;
    inherit version;
  };

  mastodon-assets = stdenv.mkDerivation {
    pname = "mastodon-assets";
    inherit src version;

    buildInputs = [
      mastodon-gems nodejs-slim yarn
    ];

    buildPhase = ''
      cp -r ${mastodon-js-modules}/libexec/*/mastodon/node_modules "node_modules"
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
  pname = "mastodon";
  inherit src version;

  passthru.updateScript = ./update.sh;

  buildPhase = ''
    ln -s ${mastodon-js-modules}/libexec/*/mastodon/node_modules node_modules
    ln -s ${mastodon-assets}/public/assets public/assets
    ln -s ${mastodon-assets}/public/packs public/packs

    patchShebangs bin/
    for b in $(ls ${mastodon-gems}/bin/)
    do
      if [ ! -f bin/$b ]; then
        ln -s ${mastodon-gems}/bin/$b bin/$b
      fi
    done

    rm -rf log
    ln -s /var/log/mastodon log
    ln -s /tmp tmp
  '';
  propagatedBuildInputs = [ imagemagick ffmpeg file mastodon-gems.wrappedRuby ];
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with stdenv.lib; {
    description = "Self-hosted, globally interconnected microblogging software based on ActivityPub";
    homepage = "https://joinmastodon.org";
    license = licenses.agpl3;
    maintainers = with maintainers; [ petabyteboy ];
  };
}

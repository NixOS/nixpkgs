{ stdenv, lib, fetchurl, makeWrapper, buildGoPackage, fetchFromGitHub
, nodejs-6_x, postgresql, ruby }:

with stdenv.lib;

let
  cli = buildGoPackage rec {
    name = "cli-${version}";
    version = "5.6.32";

    goPackagePath = "github.com/heroku/cli";

    src = fetchFromGitHub {
      owner  = "heroku";
      repo   = "cli";
      rev    = "v${version}";
      sha256 = "062aa79mv2njjb0ix7isbz6646wxmsldv27bsz5v2pbv597km0vz";
    };

    buildFlagsArray = ''
      -ldflags=
        -X=main.Version=${version}
        -X=main.Channel=stable
        -X=main.Autoupdate=no
    '';

    preCheck = ''
      export HOME=/tmp
    '';

    doCheck = true;
  };

in stdenv.mkDerivation rec {
  name = "heroku-${version}";
  version = "3.43.16";

  meta = {
    homepage = "https://toolbelt.heroku.com";
    description = "Everything you need to get started using Heroku";
    maintainers = with maintainers; [ aflatter mirdhyn peterhoeg ];
    license = licenses.mit;
    platforms = with platforms; unix;
    broken = true; # Outdated function, not supported upstream. https://github.com/NixOS/nixpkgs/issues/27447
  };

  binPath = lib.makeBinPath [ postgresql ruby ];

  buildInputs = [ makeWrapper ];

  doUnpack = false;

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-${version}.tgz";
    sha256 = "08pai3cjaj7wshhyjcmkvyr1qxv5ab980whcm406798ng8f91hn7";
  };

  installPhase = ''
    mkdir -p $out

    tar xzf $src -C $out --strip-components=1
    install -Dm755 ${cli}/bin/cli $out/share/heroku/cli/bin/heroku

    wrapProgram $out/bin/heroku \
      --set HEROKU_NODE_PATH ${nodejs-6_x}/bin/node \
      --set XDG_DATA_HOME    $out/share \
      --set XDG_DATA_DIRS    $out/share \
      --prefix PATH : ${binPath}
  '';
}

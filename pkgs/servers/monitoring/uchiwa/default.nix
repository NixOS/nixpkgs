{ stdenv, fetchFromGitHub, buildBowerComponents, buildGoPackage, makeWrapper }:

let
  inherit (import ./src.nix) version sha256;
  owner = "sensu";
  repo = "uchiwa";

  src = fetchFromGitHub {
    inherit owner repo sha256;
    rev    = "${version}";
  };

  backend = buildGoPackage {
    name = "uchiwa-backend-${version}";
    goPackagePath = "github.com/${owner}/${repo}";
    inherit src;
    postInstall = ''
      cp go/src/github.com/sensu/uchiwa/public/index.html $out/
    '';
  };

  frontend = buildBowerComponents {
    name = "uchiwa-frontend-${version}";
    generated = ./bower-packages.nix;
    inherit src;
  };

in stdenv.mkDerivation rec {
  name = "uchiwa-${version}";

  inherit src;

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin $out/public
    makeWrapper ${backend.bin}/bin/uchiwa $out/bin/uchiwa \
      --add-flags "-p $out/public"
    ln -s ${backend.out}/index.html $out/public/index.html
    ln -s ${frontend.out}/bower_components $out/public/bower_components
  '';

  meta = with stdenv.lib; {
    description = "A Dashboard for the sensu monitoring framework";
    homepage    = http://sensuapp.org/;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}

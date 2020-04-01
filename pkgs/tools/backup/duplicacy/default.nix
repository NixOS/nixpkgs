{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "duplicacy";
  version = "2.3.0";

  goPackagePath = "github.com/gilbertchen/duplicacy";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    sha256 = "12swp3kbwkmwn3g2mp964m60kabmz0ip7kkhvhiqq7k74nxzj312";
  };
  goDeps = ./deps.nix;
  buildPhase = ''
    cd go/src/${goPackagePath}
    go build duplicacy/duplicacy_main.go
  '';

  installPhase = ''
    install -D duplicacy_main $bin/bin/duplicacy
  '';

  meta = with lib; {
    homepage = https://duplicacy.com;
    description = "A new generation cloud backup tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs ];
  };
}

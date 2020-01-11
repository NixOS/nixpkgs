{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "duplicacy";
  version = "2.1.2";

  goPackagePath = "github.com/gilbertchen/duplicacy/";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    sha256 = "0v3rk4da4b6dhqq8zsr4z27wd8p7crxapkn265kwpsaa99xszzbv";
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
    description = "A new generation cloud backup tool ";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs ];
  };
}

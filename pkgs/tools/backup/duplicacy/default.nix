{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "duplicacy";
  version = "2.7.2";

  goPackagePath = "github.com/gilbertchen/duplicacy";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    sha256 = "0j37sqicj7rl982czqsl3ipxw7k8k4smcr63s0yklxwz7ch3353c";
  };
  goDeps = ./deps.nix;
  buildPhase = ''
    cd go/src/${goPackagePath}
    go build duplicacy/duplicacy_main.go
  '';

  installPhase = ''
    install -D duplicacy_main $out/bin/duplicacy
  '';

  meta = with lib; {
    homepage = "https://duplicacy.com";
    description = "A new generation cloud backup tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs ];
  };
}

{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "gosec-${version}";
  version = "1.1.0";

  goPackagePath = "github.com/securego/gosec";
  excludedPackages = ''cmd/tlsconfig'';

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "${version}";
    sha256 = "0vjn3g6w4y4ayx0g766jp31vb78cipl90fcg0mccjr0a539qrpy6";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Golang security checker";
    homepage = https://github.com/securego/gosec;
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

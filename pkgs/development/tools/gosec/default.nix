{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "gosec-${version}";
  version = "1.2.0";

  goPackagePath = "github.com/securego/gosec";
  excludedPackages = ''cmd/tlsconfig'';

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "${version}";
    sha256 = "1420yl4cjp4v4xv0l0wbahgl6bjhz77lx5va9hqa6abddmqvx1hg";
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

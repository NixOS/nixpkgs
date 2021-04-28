{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-toml";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m8VgjfNDxSX6fRG2/gEJlVc9hCnua+o79ttrd8P20kU=";
  };

  goPackagePath = "github.com/pelletier/go-toml";

  excludedPackages = [ "cmd/tomltestgen" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}

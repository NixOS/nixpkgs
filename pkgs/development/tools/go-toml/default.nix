{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-toml";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fxmjm85c9h43lvqz71wr93fcc63bhj82nwby80222xx8ja63g7y";
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

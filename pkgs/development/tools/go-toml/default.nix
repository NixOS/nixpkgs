{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-toml";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x740f6I+szhq4mEsed4bsXcC8PvzF6PKFJNJ9SKMGIE=";
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

{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "hjson-go";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X02NnSefJfKUfagzJpdW1UpOLe84SvRaTN+8GqGKzbU=";
  };

  goPackagePath = "github.com/hjson/hjson-go";

  meta = with lib;
    src.meta // {
      description = "Utility to convert JSON to and from HJSON";
      maintainers = with maintainers; [ ehmry ];
      license = licenses.mit;
    };
}

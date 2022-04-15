{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "hjson-go";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yU1VkxwQ12CjzITR9X6LLaOfiteN+807rfB/tWcRR1c=";
  };

  goPackagePath = "github.com/hjson/hjson-go";

  meta = with lib;
    src.meta // {
      description = "Utility to convert JSON to and from HJSON";
      maintainers = with maintainers; [ ehmry ];
      mainProgram = "hjson-cli";
      license = licenses.mit;
    };
}

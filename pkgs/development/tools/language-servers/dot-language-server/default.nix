{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "dot-language-server";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.27";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nikeee";
    repo = "dot-language-server";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NGkobMZrvWlW/jteFowZgGUVQiNm3bS5gv5tN2485VA=";
  };

  npmDepsHash = "sha256-spskj0vqfR9GoQeKyfLsQgRp6JasZeVLCVBt6wZiSP8=";
=======
    hash = "sha256-Dha6S+qc9rwPvxUkBXYUomyKckEcqp/ESU/24GkrmpA=";
  };

  npmDepsHash = "sha256-nI8xPCTZNqeGW4I99cDTxtVLicF1MEIMTPRp7O0bFE4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  npmBuildScript = "compile";

  meta = with lib; {
    description = "A language server for the DOT language";
    homepage = "https://github.com/nikeee/dot-language-server";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}

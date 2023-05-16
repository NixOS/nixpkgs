{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
<<<<<<< HEAD
  version = "1.12.8";
=======
  version = "1.11.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
<<<<<<< HEAD
    rev = "3909facc10fe0308d425b609675919e1b9d1b06e"; # version not tagged
    hash = "sha256-qAkrNWy7ofT2klgxU4lbZNfiPvF9gLpgkhaTW1xMcAc=";
  };

  npmDepsHash = "sha256-m0xszerBSx6Ovs/S55lT4CqPRls7aSw4bjONV7BZ8xE=";
=======
    rev = "v${version}";
    hash = "sha256-MGFVIQDb++oVbTQubl7CNYwT/ofTNFQfFiveXcNgQpA=";
  };

  npmDepsHash = "sha256-zKy/DngBwnfUqG6JfCULoDIrg1V16hX0Q4zNz45z888=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
<<<<<<< HEAD
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
=======
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/raw/v${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}

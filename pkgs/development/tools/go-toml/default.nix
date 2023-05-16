{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-BEkshlB1Zze4sVo5YDwpj6ENHFLHL4IFmOIYgrWz+gQ=";
  };

  vendorHash = "sha256-XOcCsb3zUChiYLTfOCbRQF71E2khzSt/ApFI8NAS13U=";
=======
    sha256 = "sha256-bGLJSzSwcoKRMRwLSmGEWoQaC9NVwcKyFKpcEw+/Nag=";
  };

  vendorHash = "sha256-MMCyFKqsL9aSQqK9VtPzUbgfLTFpzD5g8QYx8qIwktg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = [ "cmd/gotoml-test-decoder" "cmd/tomltestgen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
<<<<<<< HEAD
    changelog = "https://github.com/pelletier/go-toml/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oapi-codegen";
<<<<<<< HEAD
  version = "1.13.4";
=======
  version = "1.12.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-9uHgc2q3ZNM0hQsAY+1RLAH3NfcV+dQo+WRk4OQ8q4Q=";
  };

  vendorHash = "sha256-VsZcdbOGRbHfjKPU+Y01xZCBq4fiVi7qoRBY9AqS0PM=";
=======
    hash = "sha256-VbaGFTDfe/bm4EP3chiG4FPEna+uC4HnfGG4C7YUWHc=";
  };

  vendorHash = "sha256-o9pEeM8WgGVopnfBccWZHwFR420mQAA4K/HV2RcU2wU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/deepmap/oapi-codegen";
    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ j4m3s ];
  };
}

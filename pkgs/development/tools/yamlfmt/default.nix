{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yamlfmt";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+xlPXHM/4blnm09OcMSpvVTLJy38U4xkVMd3Ea2scyU=";
=======
    sha256 = "sha256-l081PgSAT9h2oHp1eH96XztcCLeyv1Y11l6lJhHQj1I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-qrHrLOfyJhsuU75arDtfOhLaLqP+GWTfX+oyLX3aea8=";

  doCheck = false;

  meta = with lib; {
    description = "An extensible command line tool or library to format yaml files.";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
<<<<<<< HEAD
    mainProgram = "yamlfmt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

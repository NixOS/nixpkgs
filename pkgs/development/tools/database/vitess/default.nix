{ lib, buildGoModule, fetchFromGitHub, sqlite }:

buildGoModule rec {
  pname = "vitess";
<<<<<<< HEAD
  version = "17.0.2";
=======
  version = "16.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uST+FtYhGIn/Tieyofbh2r8xonw8qsS6ODrpd/A27r4=";
  };

  vendorHash = "sha256-0OrPbMG7ElOD+9/kWx1HtvGUBiFpIsNs5Vu7QofzE6Q=";
=======
    hash = "sha256-2iy80Ac8yh7lTiM53qXygVX/n3r2C/MmijoQRXIhoRk=";
  };

  vendorHash = "sha256-hC0skrEDXn6SXjH75ur77I0pHnGSURErAy97lmVvqro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = with lib; {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${version}";
    description = "A database clustering system for horizontal scaling of MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}

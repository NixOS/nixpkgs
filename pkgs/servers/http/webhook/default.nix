{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "webhook";
<<<<<<< HEAD
  version = "2.8.1";
=======
  version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-8OpVpm9nEroUlr41VgnyM6sxd/FlSvoQK5COOWvo4Y4=";
  };

  vendorHash = null;
=======
    sha256 = "0n03xkgwpzans0cymmzb0iiks8mi2c76xxdak780dk0jbv6qgp5i";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  doCheck = false;

  passthru.tests = { inherit (nixosTests) webhook; };

  meta = with lib; {
    description = "Incoming webhook server that executes shell commands";
    homepage = "https://github.com/adnanh/webhook";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}

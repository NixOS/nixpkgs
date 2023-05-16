{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chopchop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "michelin";
    repo = "ChopChop";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qSBQdcS6d0tctSHRbkY4T7s6Zj7xI2abaPUvNKh1M2E=";
  };

  vendorHash = "sha256-UxWARWOFp8AYKEdiJwRZNwFrphgMTJSZjnvktTNOsgU=";
=======
    sha256 = "qSBQdcS6d0tctSHRbkY4T7s6Zj7xI2abaPUvNKh1M2E=";
  };

  vendorSha256 = "UxWARWOFp8AYKEdiJwRZNwFrphgMTJSZjnvktTNOsgU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "CLI to search for sensitive services/files/folders";
    homepage = "https://github.com/michelin/ChopChop";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

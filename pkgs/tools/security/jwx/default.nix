{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
<<<<<<< HEAD
  version = "2.0.12";
=======
  version = "2.0.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2Lx9pu5KQut9eXIQYDjFW/pMDzR0eSKMFtSGOPQAkN4=";
  };

  vendorHash = "sha256-o3EHPIXGLz/io0d8jhl9cxzctP3CeOjEDMQl1SY9lXg=";

  sourceRoot = "${src.name}/cmd/jwx";
=======
    hash = "sha256-0Ha16moHpPt7IwSmSLSf3ExKlp2TDkssPppNIPHrsJw=";
  };

  vendorHash = "sha256-RyAQh1uXw3bEZ6vuh8+mEf8T4l3ZIFAaFJ6dGMoANys=";

  sourceRoot = "source/cmd/jwx";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}

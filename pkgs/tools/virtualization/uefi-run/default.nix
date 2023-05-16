{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "uefi-run";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Richard-W";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tR547osqw18dCMHJLqJ8AQBelbv8yCl7rAqslu+vnDQ=";
  };

  cargoHash = "sha256-s1Kbc3JHoYy0UJwNfSunIdQ3xHjlQaut/Cb0JSYyB9g=";
=======
    sha256 = "sha256-OL21C3J4M7q1nNB6lL9xaU6ryZN45UDUqiKsbqQhYH8=";
  };

  cargoSha256 = "sha256-ieX8jQKv9Fht1p7JtTieZ5M+rXdn6/Oo/LgJ8NEBIuQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = licenses.mit;
    maintainers = [ maintainers.maddiethecafebabe ];
  };
}

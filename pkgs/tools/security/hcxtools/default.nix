{ lib, stdenv, fetchFromGitHub, pkg-config, curl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "hcxtools";
<<<<<<< HEAD
  version = "6.3.1";
=======
  version = "6.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-EDTxzstQwQy7MSkdi1nQis8qEm8ZPblkeOkM8B48IRE=";
=======
    sha256 = "sha256-p1G+Kxh0OfTRDTSBl2NxhRrQYsehGuCxmGU87CBjyW0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl openssl zlib ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = "https://github.com/ZerBea/hcxtools";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dywedir ];
  };
}

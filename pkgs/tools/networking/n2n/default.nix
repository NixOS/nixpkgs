<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libcap }:
=======
{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "n2n";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "n2n";
    rev = version;
    hash = "sha256-OXmcc6r+fTHs/tDNF3akSsynB/bVRKB6Fl5oYxmu+E0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

<<<<<<< HEAD
  buildInputs = [
    libcap
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    patchShebangs autogen.sh
  '';

  preAutoreconf = ''
    ./autogen.sh
  '';

  PREFIX = placeholder "out";

  meta = with lib; {
    description = "Peer-to-peer VPN";
    homepage = "https://www.ntop.org/products/n2n/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ malte-v ];
  };
}

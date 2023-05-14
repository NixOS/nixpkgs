{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

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

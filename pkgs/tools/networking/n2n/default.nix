{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "n2n";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "n2n";
    rev = version;
    hash = "sha256-2xJ8gYVZJZoKs6PZ/9GacgxQ+/3tmnRntT1AbPe1At4=";
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
    maintainers = with maintainers; [ malvo ];
  };
}

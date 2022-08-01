{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "n2n";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "n2n";
    rev = version;
    hash = "sha256-/Yb6L6Pt2vR7fzVS1QS9Z46yaR26fqE7LPrAEHl5sbw=";
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

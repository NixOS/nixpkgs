{ lib, stdenv
, cmake
, fetchFromGitHub
, i3
, jsoncpp
, libsigcxx
, libX11
, libxkbfile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "xkb-switch-i3";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "Zebradil";
    repo = "xkb-switch-i3";
    rev = version;
    sha256 = "sha256-oW1oXxYqaLTnVQMBEOFPdzS8EnpoPc68kbGxGXaWUB8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ i3 jsoncpp libsigcxx libX11 libxkbfile ];

  meta = with lib; {
    description = "Switch your X keyboard layouts from the command line(i3 edition)";
    homepage = "https://github.com/Zebradil/xkb-switch-i3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
  };
}

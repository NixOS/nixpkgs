{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, xorg
}:

stdenv.mkDerivation rec {
  pname = "xprintidle";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "g0hl1n";
    repo = "xprintidle";
    rev = version;
    sha256 = "sha256-CgjHTvwQKR/TPQyEWKxN5j97Sh2iec0BQPhC96sfyoI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    xorg.libXScrnSaver
    xorg.libX11
    xorg.libXext
  ];

  meta = with lib; {
    homepage = "https://github.com/g0hl1n/xprintidle";
    description = "A utility that queries the X server for the user's idle time and prints it to stdout";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}

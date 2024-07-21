{ lib, stdenv
, fetchFromGitHub
, xorg
, pkg-config
, wrapGAppsHook3
, go
}:

stdenv.mkDerivation rec {
  pname = "ibus-bamboo";
  version = "0.8.4-rc6";

  src = fetchFromGitHub {
    owner = "BambooEngine";
    repo = pname;
    rev = "v" + lib.toUpper version;
    sha256 = "sha256-8eBrgUlzrfQkgzr0/Nz/0FQ98UBdV0GQcZhJVbmyOg0=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    go
  ];

  buildInputs = [
    xorg.libXtst
  ];

  preConfigure = ''
    export GOCACHE="$TMPDIR/go-cache"
    sed -i "s,/usr,$out," data/bamboo.xml
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];


  meta = with lib; {
    isIbusEngine = true;
    description = "Vietnamese IME for IBus";
    homepage = "https://github.com/BambooEngine/ibus-bamboo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astronaut0212 ];
  };
}

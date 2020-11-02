{ stdenv
, fetchFromGitHub
, gettext
, xorg
, pkgconfig
, wrapGAppsHook
, ibus
, gtk3
, go
}:

stdenv.mkDerivation rec {
  pname = "ibus-bamboo";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "BambooEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w3z36p8d3a04fgzc12xnpdkg6h8alfgqy5rjxbwqwi25h3byj6k";
  };

  nativeBuildInputs = [
    gettext
    pkgconfig
    wrapGAppsHook
    go
  ];

  buildInputs = [
    xorg.libX11
    xorg.xorgproto
    xorg.libXtst
    xorg.libXi
  ];

  preConfigure = ''
    export GOCACHE="$TMPDIR/go-cache"
    sed -i "s,/usr,$out," bamboo.xml
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];


  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "A Vietnamese IME for IBus";
    homepage = "https://github.com/BambooEngine/ibus-bamboo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ superbo ];
  };
}

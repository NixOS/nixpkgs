{ lib, stdenv
, fetchFromGitHub
, gettext
, xorg
, pkg-config
, wrapGAppsHook
, ibus
, gtk3
, go
}:

stdenv.mkDerivation rec {
  pname = "ibus-bamboo";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "BambooEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7UXURvZX5UrpLHFYgBnuTX/sKQkubnBlvkSD/WBa4ZU=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
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


  meta = with lib; {
    isIbusEngine = true;
    description = "A Vietnamese IME for IBus";
    homepage = "https://github.com/BambooEngine/ibus-bamboo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ superbo ];
  };
}

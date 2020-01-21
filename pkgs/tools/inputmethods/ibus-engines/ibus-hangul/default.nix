{ stdenv
, fetchurl
, substituteAll
, appstream-glib
, gettext
, pkgconfig
, wrapGAppsHook
, gtk3
, ibus
, libhangul
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-hangul";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/choehwanjin/ibus-hangul/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1400ba2p34vr9q285lqvjm73f6m677cgfdymmjpiwyrjgbbiqrjy";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libhangul = "${libhangul}/lib/libhangul.so.1";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    gettext
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    ibus
    libhangul
    (python3.withPackages (pypkgs: with pypkgs; [
      pygobject3
      (toPythonModule ibus)
    ]))
  ];

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "Ibus Hangul engine";
    homepage = https://github.com/choehwanjin/ibus-hangul;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}

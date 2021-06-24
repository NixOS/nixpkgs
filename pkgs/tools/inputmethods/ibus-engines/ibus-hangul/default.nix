{ lib, stdenv
, fetchurl
, substituteAll
, appstream-glib
, gettext
, pkg-config
, wrapGAppsHook
, gtk3
, ibus
, libhangul
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-hangul";
  version = "1.5.4";

  src = fetchurl {
    url = "https://github.com/choehwanjin/ibus-hangul/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1q6g2pnrn5gqn9jqnm3975v9hh60hc5gn9x3zbrdjgy0n3wpxwm9";
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
    pkg-config
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

  meta = with lib; {
    isIbusEngine = true;
    description = "Ibus Hangul engine";
    homepage = "https://github.com/choehwanjin/ibus-hangul";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}

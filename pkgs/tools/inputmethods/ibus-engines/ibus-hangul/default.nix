{ lib, stdenv
, fetchurl
, substituteAll
, appstream-glib
, gettext
, pkg-config
, wrapGAppsHook3
, gtk3
, ibus
, libhangul
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-hangul";
  version = "1.5.5";

  src = fetchurl {
    url = "https://github.com/libhangul/ibus-hangul/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-parIgobNGJYCKYYOPhp3iXinrqpIStms+kgoS4f9w7s=";
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
    wrapGAppsHook3
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
    mainProgram = "ibus-setup-hangul";
    homepage = "https://github.com/libhangul/ibus-hangul";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}

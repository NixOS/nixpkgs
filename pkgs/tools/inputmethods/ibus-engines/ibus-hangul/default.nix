{ stdenv
, fetchurl
, substituteAll
, intltool
, pkgconfig
, wrapGAppsHook
, gtk3
, ibus
, libhangul
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-hangul";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/choehwanjin/ibus-hangul/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0gha8dfdf54rx8fv3yfikbgdg6lqq6l883lhg7q68ybvkjx9bwbs";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libhangul = "${libhangul}/lib/libhangul.so.1";
    })
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
    python3.pkgs.wrapPython
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

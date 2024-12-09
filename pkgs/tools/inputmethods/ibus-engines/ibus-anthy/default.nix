{ lib, stdenv
, fetchurl
, gettext
, pkg-config
, wrapGAppsHook3
, anthy
, ibus
, glib
, gobject-introspection
, gtk3
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-anthy";
  version = "1.5.16";

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-FVIiFLWK2ISsydmx2hPxXbfc12w7GKiFCQRuXsYT0a4=";
  };

  buildInputs = [
    anthy
    glib
    gtk3
    ibus
    (python3.withPackages (ps: [
      ps.pygobject3
      (ps.toPythonModule ibus)
    ]))
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  configureFlags = [
    "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t"
  ];

  postFixup = ''
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
  '';

  meta = with lib; {
    isIbusEngine = true;
    description = "IBus interface to the anthy input method";
    homepage = "https://github.com/fujiwarat/ibus-anthy";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ericsagnes ];
  };
}

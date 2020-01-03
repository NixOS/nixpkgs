{ stdenv
, fetchurl
, gettext
, pkgconfig
, wrapGAppsHook
, anthy
, ibus
, glib
, gobject-introspection
, gtk3
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-anthy";
  version = "1.5.11";

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1zwgswpibh67sgbza8kvg03v06maxc08ihkgm5hmh333sjq9d5c0";
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
    pkgconfig
    wrapGAppsHook
  ];

  configureFlags = [
    "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t"
  ];

  postFixup = ''
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "IBus interface to the anthy input method";
    homepage = https://github.com/fujiwarat/ibus-anthy;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ericsagnes ];
  };
}

{ stdenv, fetchurl, intltool, pkgconfig
, anthy, ibus, glib, gobject-introspection, gtk3, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-anthy";
  version = "1.5.11";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "IBus interface to the anthy input method";
    homepage     = https://github.com/fujiwarat/ibus-anthy;
    license      = licenses.gpl2Plus;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ gebner ericsagnes ];
  };

  configureFlags = [ "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t" ];

  buildInputs = [
    anthy glib gobject-introspection gtk3 ibus (python3.withPackages (ps: [ps.pygobject3]))
  ];

  nativeBuildInputs = [ intltool pkgconfig python3.pkgs.wrapPython ];

  postFixup = ''
    wrapPythonPrograms
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
  '';

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1zwgswpibh67sgbza8kvg03v06maxc08ihkgm5hmh333sjq9d5c0";
  };
}

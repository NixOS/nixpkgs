{ stdenv, fetchurl, intltool, pkgconfig
, anthy, ibus, glib, gobjectIntrospection, gtk3, python3
}:

stdenv.mkDerivation rec {
  name = "ibus-anthy-${version}";
  version = "1.5.8";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "IBus interface to the anthy input method";
    homepage     = http://wiki.github.com/fujiwarat/ibus-anthy;
    license      = licenses.gpl2Plus;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ gebner ericsagnes ];
  };

  configureFlags = [ "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t" ];

  buildInputs = [
    anthy glib gobjectIntrospection gtk3 ibus python3
  ];

  nativeBuildInputs = [ intltool pkgconfig python3.pkgs.wrapPython ];

  postFixup = ''
    wrapPythonPrograms
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
  '';

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${version}/${name}.tar.gz";
    sha256 = "1aj7vnfky7izl23xyjky78z3qas3q72l3kr8dnql2lnivsrb8q1y";
  };
}

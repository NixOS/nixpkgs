{ stdenv, fetchurl, intltool, pkgconfig
, anthy, ibus, glib, gobjectIntrospection, gtk3, python3
}:

stdenv.mkDerivation rec {
  name = "ibus-anthy-${version}";
  version = "1.5.10";

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
    anthy glib gobjectIntrospection gtk3 ibus (python3.withPackages (ps: [ps.pygobject3]))
  ];

  nativeBuildInputs = [ intltool pkgconfig python3.pkgs.wrapPython ];

  postFixup = ''
    wrapPythonPrograms
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
  '';

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${version}/${name}.tar.gz";
    sha256 = "0jpqz7pb9brlqiwrbr3i6wvj3b39a9bs9lljl3qa3r77mz8y0cyc";
  };
}

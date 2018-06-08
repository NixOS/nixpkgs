{ stdenv, fetchFromGitHub, intltool, pkgconfig
, anthy, ibus, glib, gobjectIntrospection, gtk3, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-anthy";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = pname;
    rev = version;
    sha256 = "07qyfdra2lc91jn35inraxbjqzni6yzx59a17k968pspx8lzdx02";
  };

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
}

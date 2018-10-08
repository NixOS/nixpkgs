{stdenv, fetchFromGitHub, pkgconfig, glib, gtk2, python2Packages }:

stdenv.mkDerivation rec {
  version = "0.14.7";
  name = "bootchart-${version}";

  src = fetchFromGitHub {
    owner = "mmeeks";
    repo = "bootchart";
    rev = version;
    sha256 = "178p7z5npx2ksqx477454n1l5560ncbpjh65j9dr001wmwzqzh5q";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gtk2 python2Packages.python python2Packages.wrapPython python2Packages.pygtk ];
  pythonPath = with python2Packages; [ pygtk pycairo ];

  installPhase = ''
    make install DESTDIR=$out BINDIR=/bin PY_LIBDIR=/lib/${python2Packages.python.libPrefix}
    wrapProgram $out/bin/pybootchartgui \
      --prefix PYTHONPATH : "$PYTHONPATH:$(toPythonPath $out)"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.bootchart.org/;
    description = "Performance analysis and visualization of the GNU/Linux boot process";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };

}

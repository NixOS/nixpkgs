{stdenv, fetchurl, lib, pkgconfig, glib, gtk2, python27, python2Packages }:

stdenv.mkDerivation rec {
  version = "0.14.7";
  name = "bootchart-${version}";

  src = fetchurl {
    url = "https://github.com/mmeeks/bootchart/archive/${version}.tar.gz";
    sha256 = "1abn4amsyys6vwn7csxsxny94n24ycca3xhqxqcmdc4j0dzn3kmb";
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

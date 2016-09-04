{stdenv, fetchurl, lib, pkgconfig, glib, gtk, python27, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.14.7";
  name = "bootchart-${version}";

  src = fetchurl {
    url = "https://github.com/mmeeks/bootchart/archive/${version}.tar.gz";
    sha256 = "1abn4amsyys6vwn7csxsxny94n24ycca3xhqxqcmdc4j0dzn3kmb";
  };

  buildInputs = [ pkgconfig glib gtk python27 pythonPackages.wrapPython pythonPackages.pygtk ];
  pythonPath = with pythonPackages; [ pygtk pycairo ];

  installPhase = ''
    make install DESTDIR=$out BINDIR=/bin PY_LIBDIR=/lib/python2.7
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

{ lib, fetchurl, mkPythonDerivation, python, isPyPy }:

if isPyPy then throw "sip not supported for interpreter ${python.executable}" else mkPythonDerivation rec {
  name = "sip-4.18.1";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "1452zy3g0qv4fpd9c0y4gq437kn0xf7bbfniibv5n43zpwnpmklv";
  };

  configurePhase = ''
    ${python.executable} ./configure.py \
      -d $out/lib/${python.libPrefix}/site-packages \
      -b $out/bin -e $out/include
  '';

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander urkud ];
    platforms   = platforms.all;
  };
}

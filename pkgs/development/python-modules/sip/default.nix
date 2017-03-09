{ lib, fetchurl, mkPythonDerivation, python, isPyPy }:

if isPyPy then throw "sip not supported for interpreter ${python.executable}" else mkPythonDerivation rec {
  name = "sip-4.19.1";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "501852b8325349031b769d1c03d6eab04f7b9b97f790ec79f3d3d04bf065d83e";
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

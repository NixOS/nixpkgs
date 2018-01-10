{ lib, fetchurl, buildPythonPackage, python, isPyPy }:

if isPyPy then throw "sip not supported for interpreter ${python.executable}" else buildPythonPackage rec {
  pname = "sip";
  version = "4.19.6";
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "0nlj0zbvmzliyhhspqwf2bjvcnpq4agx4s47php7ishv32p2gnlx";
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
    maintainers = with maintainers; [ lovek323 sander ];
    platforms   = platforms.all;
  };
}

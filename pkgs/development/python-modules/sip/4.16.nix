{ stdenv, fetchurl, python, isPyPy }:

if isPyPy then throw "sip not supported for interpreter ${python.executable}" else stdenv.mkDerivation rec {
  name = "sip-4.16.4";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "1xapklcz5ndilax0gr2h1fqzhdzh7yvxfb3y0rxfcag1qlzl9nnf";
  };

  configurePhase = ''
    ${python.executable} ./configure.py \
      -d $out/lib/${python.libPrefix}/site-packages \
      -b $out/bin -e $out/include
  '';

  buildInputs = [ python ];

  meta = with stdenv.lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander urkud ];
    platforms   = platforms.all;
  };
}

{ stdenv, fetchurl, python, isPyPy }:

if isPyPy then throw "sip not supported for interpreter ${python.executable}" else stdenv.mkDerivation rec {
  name = "sip-4.16.6";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "0lj5f581dkwswlwpg7lbicqf940dvrp8vjbkhmyywd99ynxb4zcc";
  };

  configurePhase = ''
    ${python.executable} ./configure.py \
      -d $out/lib/${python.libPrefix}/site-packages \
      -b $out/bin -e $out/include
  '';

  buildInputs = [ python ];

  passthru.pythonPath = [];

  meta = with stdenv.lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander urkud ];
    platforms   = platforms.all;
  };
}

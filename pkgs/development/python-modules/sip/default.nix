{ stdenv, fetchurl, python, isPyPy }:

if isPyPy then throw "sip not supported for interpreter ${python.executable}" else stdenv.mkDerivation rec {
  name = "sip-4.14.7"; # kde410.pykde4 doesn't build with 4.15

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "1dv1sdwfmnq481v80k2951amzs9s87d4qhk0hpwrhb1sllh92rh5";
  };

  configurePhase = stdenv.lib.optionalString stdenv.isDarwin ''
    # prevent sip from complaining about python not being built as a framework
    sed -i -e 1564,1565d siputils.py
  '' + ''
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

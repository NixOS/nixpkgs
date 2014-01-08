{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.15.4";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "0a12lmqkf342yg42ygnjm1fyldcx9pzhy7z68p4ms4ydfcl78jsr";
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

  meta = with stdenv.lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander urkud ];
    platforms   = platforms.all;
  };
}

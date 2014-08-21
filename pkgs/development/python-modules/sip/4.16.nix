{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.16.1";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${name}/${name}.tar.gz";
    sha256 = "1hknl71ij924syc9ik9nk4z051q3n75y7w27q9i07awpd39sp7m4";
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

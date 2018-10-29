{ lib, fetchurl, buildPythonPackage, python, isPyPy }:

buildPythonPackage rec {
  pname = "sip";
  version = "4.19.13";
  format = "other";

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0pniq03jk1n5bs90yjihw3s3rsmjd8m89y9zbnymzgwrcl2sflz3";
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

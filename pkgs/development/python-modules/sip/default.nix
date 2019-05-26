{ lib, fetchurl, buildPythonPackage, python, isPyPy, sip-module ? "sip" }:

buildPythonPackage rec {
  pname = sip-module;
  version = "4.19.13";
  format = "other";

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/sip-${version}/sip-${version}.tar.gz";
    sha256 = "0pniq03jk1n5bs90yjihw3s3rsmjd8m89y9zbnymzgwrcl2sflz3";
  };

  configurePhase = ''
    ${python.executable} ./configure.py \
      --sip-module ${sip-module} \
      -d $out/lib/${python.libPrefix}/site-packages \
      -b $out/bin -e $out/include
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander ];
    platforms   = platforms.all;
  };
}

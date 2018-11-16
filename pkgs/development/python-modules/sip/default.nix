{ lib, fetchurl, buildPythonPackage, python, isPyPy }:

buildPythonPackage rec {
  pname = "sip";
  version = "4.19.8";
  format = "other";

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1g4pq9vj753r2s061jc4y9ydzgb48ibhc9bdvmb8mlyllwp7mbvy";
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

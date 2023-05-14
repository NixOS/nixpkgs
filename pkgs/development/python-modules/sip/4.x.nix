{ lib, fetchurl, buildPythonPackage, python, isPyPy, pythonAtLeast, sip-module ? "sip" }:

buildPythonPackage rec {
  pname = sip-module;
  version = "4.19.25";
  format = "other";

  disabled = isPyPy || pythonAtLeast "3.11";

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/sip/${version}/sip-${version}.tar.gz";
    sha256 = "04a23cgsnx150xq86w1z44b6vr2zyazysy9mqax0fy346zlr77dk";
  };

  configurePhase = ''
    ${python.executable} ./configure.py \
      --sip-module ${sip-module} \
      -d $out/${python.sitePackages} \
      -b $out/bin -e $out/include
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [ sip-module "sipconfig" ];

  doCheck = true;

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander ];
    platforms   = platforms.all;
  };
}

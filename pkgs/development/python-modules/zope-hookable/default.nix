{ lib
, buildPythonPackage
, fetchPypi
, zope-testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "6.0";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    hash = "sha256-FmiZPUCnz9yGeEPdVyWSnn+DpbDBlccJrx2u+CdPQ8s=";
  };

  nativeCheckInputs = [ zope-testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}

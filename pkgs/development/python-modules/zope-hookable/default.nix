{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    hash = "sha256-FmiZPUCnz9yGeEPdVyWSnn+DpbDBlccJrx2u+CdPQ8s=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ zope-testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}

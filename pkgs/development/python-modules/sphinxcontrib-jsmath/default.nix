{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-jsmath";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qZJeSkWHJH7SGRoi319pcGVsuMor1ihDCVePIVPgxLg=";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx extension which renders display math in HTML via JavaScript";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-jsmath";
    license = lib.licenses.bsd0;
  };
})

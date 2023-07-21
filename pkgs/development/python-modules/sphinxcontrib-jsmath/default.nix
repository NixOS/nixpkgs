{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-jsmath";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qZJeSkWHJH7SGRoi319pcGVsuMor1ihDCVePIVPgxLg=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-jsmath is a sphinx extension which renders display math in HTML via JavaScript.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-jsmath";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}

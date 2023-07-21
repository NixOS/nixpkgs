{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-devhelp";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/38a+nuWQucGA3k2CmfpxB6PMSHyzpFkJm9hufSzOOQ=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp document.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-devhelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}

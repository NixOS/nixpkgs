{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-serializinghtml";
  version = "1.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ql9t5d/fgJ71BcSJXlHvXJ6sF9Dyh5M+tJ7ElSgLaVI=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-serializinghtml is a sphinx extension which outputs \"serialized\" HTML files (json and pickle).";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-serializinghtml";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}

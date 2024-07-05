{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-serializinghtml";
  version = "1.1.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_serializinghtml";
    inherit version;
    hash = "sha256-k/P13EWLkbGS/hDDl+Mk8mLPFj158ygsFY6ENqLEUR8=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "sphinxcontrib-serializinghtml is a sphinx extension which outputs \"serialized\" HTML files (json and pickle)";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-serializinghtml";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}

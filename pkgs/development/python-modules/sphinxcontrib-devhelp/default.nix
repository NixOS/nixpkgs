{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-devhelp";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_devhelp";
    inherit version;
    hash = "sha256-mJP9P5BQa8S5e9uXfOuPvYI5ifQxayjDhB7BKFRDctM=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp document";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-devhelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}

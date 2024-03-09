{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_applehelp";
    inherit version;
    hash = "sha256-Of3I12LTOwGn2PAmo7fXFWPqO3J4fV8ArYRlvZ1t+/o=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}

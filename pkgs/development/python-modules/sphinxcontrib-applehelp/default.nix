{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "1.0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-go+GeUW745gXwhChq/0bxIlci3P8qt5W1FNXo0igfX4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}

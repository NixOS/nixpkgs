{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1549cbe5b47b6ba67bdeea31720f5c51431a4d0c076c1557952d841f7223519";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml pathspec ];

  # Two test failures
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonringer mikefaille ];
  };
}

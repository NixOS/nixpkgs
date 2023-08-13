{ lib, buildPythonPackage, fetchPypi, toml }:

buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g6DO3TRJ45RjB4EaTHudicS1/UZKL7XuzNCluxWK5cg=";
  };

  propagatedBuildInputs = [ toml ];

  # Requires pytest, circular dependency
  doCheck = false;
  pythonImportsCheck = [ "setuptools_scm" ];

  meta = with lib; {
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

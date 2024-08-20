{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "yamlordereddictloader";
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nq8vYhD8/12k/EwS4dgV+XPc60EETnleHwYRXWNLyhM=";
  };

  propagatedBuildInputs = [ pyyaml ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "yamlordereddictloader" ];

  meta = with lib; {
    description = "YAML loader and dump for PyYAML allowing to keep keys order";
    homepage = "https://github.com/fmenabe/python-yamlordereddictloader";
    license = licenses.mit;
    maintainers = [ ];
  };
}

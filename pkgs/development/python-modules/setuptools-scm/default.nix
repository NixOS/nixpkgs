{ lib, buildPythonPackage, fetchPypi, toml }:

buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1925a69cb07e9b29416a275b9fadb009a23c148ace905b2fb220649a6c18e92";
  };

  propagatedBuildInputs = [ toml ];

  # Requires pytest, circular dependency
  doCheck = false;
  pythonImportsCheck = [ "setuptools_scm" ];

  meta = with lib; {
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ultraheat-api";
  version = "0.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ultraheat_api";
    inherit version;
    hash = "sha256-7yZATv0cgjRnvD9u34iZtsdsfEkdbAoVWJ19+HHlrzI=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Source is not tagged, only PyPI releases
  doCheck = false;

  pythonImportsCheck = [
    "ultraheat_api"
  ];

  meta = with lib; {
    description = "Module for working with data from Landis+Gyr Ultraheat heat meter unit";
    homepage = "https://github.com/vpathuis/uh50";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

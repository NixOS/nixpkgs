{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  version = "2024.1.12";
  pname = "uuid6";
  disabled = pythonOlder "3.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Qr7OpcwV1dfmIMgG67+QCeHyl4R4dJON3GQ8MQ/GZM=";
  };

  buildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "uuid6"
  ];

  meta = with lib; {
    description = "New time-based UUID formats which are suited for use as a database key";
    homepage = "https://github.com/oittaa/uuid6-python";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}

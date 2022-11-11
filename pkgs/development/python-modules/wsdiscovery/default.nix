{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, netifaces
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wsdiscovery";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andreikop";
    repo = "python-ws-discovery";
    rev = version;
    hash = "sha256-6LGZogNRCnmCrRXvHq9jmHwqW13KQPpaGaao/52JPtk=";
  };

  propagatedBuildInputs = [
    click
    netifaces
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "wsdiscovery"
  ];

  meta = with lib; {
    description = "WS-Discovery implementation for Python";
    homepage = "https://github.com/andreikop/python-ws-discovery";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}

{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mock,
  netifaces,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wsdiscovery";
  version = "2.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "andreikop";
    repo = "python-ws-discovery";
    rev = "v${version}";
    hash = "sha256-6LGZogNRCnmCrRXvHq9jmHwqW13KQPpaGaao/52JPtk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    netifaces
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wsdiscovery" ];

  meta = with lib; {
    description = "WS-Discovery implementation for Python";
    homepage = "https://github.com/andreikop/python-ws-discovery";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}

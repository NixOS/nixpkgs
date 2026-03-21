{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mock,
  netifaces,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wsdiscovery";
  version = "2.1.2";
  pyproject = true;

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

  meta = {
    description = "WS-Discovery implementation for Python";
    homepage = "https://github.com/andreikop/python-ws-discovery";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}

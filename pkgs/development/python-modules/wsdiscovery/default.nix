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
    hash = "sha256-c9ExGiNo0j+h1U9yKU3OtInawJXivBxdzAGvrSfi7VE=";
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

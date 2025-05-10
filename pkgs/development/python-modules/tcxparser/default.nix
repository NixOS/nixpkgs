{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tcxparser";
  version = "2.4.0-r1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vkurup";
    repo = "python-tcxparser";
    tag = version;
    hash = "sha256-lQczTuxmxu4nCPJsgblrW2RXST7kvhtPnscemwXCx0Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tcxparser" ];

  meta = with lib; {
    description = "Simple parser for Garmin TCX files";
    homepage = "https://github.com/vkurup/python-tcxparser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "starkbank";
    repo = "ecdsa-python";
    tag = "v${version}";
    hash = "sha256-HarlCDE2qOLbyhMLOE++bTC+7srJqwmohM6vrJkJ/gc=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd tests
  '';

  enabledTestPaths = [
    "*.py"
  ];

  pytestFlags = [
    "-v"
  ];

  pythonImportsCheck = [ "ellipticcurve" ];

  meta = with lib; {
    description = "Python ECDSA library";
    homepage = "https://github.com/starkbank/ecdsa-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

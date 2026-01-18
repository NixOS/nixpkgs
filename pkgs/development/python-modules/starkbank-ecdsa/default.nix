{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "2.2.0";
  format = "setuptools";

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

  meta = {
    description = "Python ECDSA library";
    homepage = "https://github.com/starkbank/ecdsa-python";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}

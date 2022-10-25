{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "starkbank";
    repo = "ecdsa-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-HarlCDE2qOLbyhMLOE++bTC+7srJqwmohM6vrJkJ/gc=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    cd tests
  '';

  pytestFlagsArray = [
    "-v"
    "*.py"
  ];

  pythonImportsCheck = [
    "ellipticcurve"
  ];

  meta = with lib; {
    description = "Python ECDSA library";
    homepage = "https://github.com/starkbank/ecdsa-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

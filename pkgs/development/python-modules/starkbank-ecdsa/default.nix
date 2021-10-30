{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "starkbank";
    repo = "ecdsa-python";
    rev = "v${version}";
    sha256 = "sha256-MTd9aeX6UavRua0hnuy5qY5kltzSoyvv+LcL5EvU5Sc=";
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

{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "2.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "starkbank";
    repo = "ecdsa-python";
    rev = "v${version}";
    sha256 = "sha256-UA+UuSxKZZN7Zb23HWsCD6UZK6lROpy3OfLN7MAlMM0=";
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

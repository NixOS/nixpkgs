{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "starkbank-ecdsa";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "starkbank";
    repo = "ecdsa-python";
    rev = "v${version}";
    sha256 = "1x86ia0385c76nzqa00qyrvnn4j174n6piq85m7ar5i0ij7qky9a";
  };

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "-v tests/*.py" ];
  pythonImportsCheck = [ "ellipticcurve" ];

  meta = with lib; {
    description = "Python ECDSA library";
    homepage = "https://github.com/starkbank/ecdsa-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

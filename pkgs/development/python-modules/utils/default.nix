{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "utils";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "haaksmash";
    repo = "pyutils";
    rev = version;
    sha256 = "07pr39cfw5ayzkp6h53y7lfpd0w19pphsdzsf100fsyy3npavgbr";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "utils" ];

  meta = with lib; {
    description = "Python set of utility functions and objects";
    homepage = "https://github.com/haaksmash/pyutils";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}

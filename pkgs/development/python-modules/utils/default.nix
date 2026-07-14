{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "utils";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "haaksmash";
    repo = "pyutils";
    rev = version;
    sha256 = "07pr39cfw5ayzkp6h53y7lfpd0w19pphsdzsf100fsyy3npavgbr";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "utils" ];

  meta = {
    description = "Python set of utility functions and objects";
    homepage = "https://github.com/haaksmash/pyutils";
    license = with lib.licenses; [ lgpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}

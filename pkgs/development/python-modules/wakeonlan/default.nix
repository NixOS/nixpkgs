{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "3.1.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    rev = "refs/tags/${version}";
    hash = "sha256-VPdklyD3GVn0cex4I6zV61I0bUr4KQp8DdMKAM/r4io=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test_wakeonlan.py"
  ];

  pythonImportsCheck = [
    "wakeonlan"
  ];

  meta = with lib; {
    description = "Python module for wake on lan";
    homepage = "https://github.com/remcohaszing/pywakeonlan";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}

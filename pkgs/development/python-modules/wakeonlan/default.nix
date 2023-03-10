{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "3.0.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    rev = "refs/tags/${version}";
    sha256 = "sha256-7BDE7TmTT8rSaG0rEn5QwH+izGWA2PeQzxpGiv7+3fo=";
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

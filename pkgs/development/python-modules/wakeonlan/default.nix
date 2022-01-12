{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "2.1.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    rev = version;
    sha256 = "sha256-5ri4bXc0EMNntzmcUZYpRIfaXoex4s5M6psf/9ta17Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
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

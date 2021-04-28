{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "2.0.1";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    rev = version;
    sha256 = "sha256-WgoL8ntfEaHcvVbJjdewe0wE31Lq7WBj8Bppeq1uJx8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test_wakeonlan.py" ];

  pythonImportsCheck = [ "wakeonlan" ];

  meta = with lib; {
    description = "A small python module for wake on lan";
    homepage = "https://github.com/remcohaszing/pywakeonlan";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}

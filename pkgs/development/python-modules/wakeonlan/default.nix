{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    rev = "refs/tags/${version}";
    hash = "sha256-VPdklyD3GVn0cex4I6zV61I0bUr4KQp8DdMKAM/r4io=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test_wakeonlan.py" ];

  pythonImportsCheck = [ "wakeonlan" ];

  meta = with lib; {
    description = "Python module for wake on lan";
    mainProgram = "wakeonlan";
    homepage = "https://github.com/remcohaszing/pywakeonlan";
    changelog = "https://github.com/remcohaszing/pywakeonlan/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}

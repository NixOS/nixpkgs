{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    tag = version;
    hash = "sha256-VPdklyD3GVn0cex4I6zV61I0bUr4KQp8DdMKAM/r4io=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_wakeonlan.py" ];

  pythonImportsCheck = [ "wakeonlan" ];

  meta = {
    description = "Python module for wake on lan";
    mainProgram = "wakeonlan";
    homepage = "https://github.com/remcohaszing/pywakeonlan";
    changelog = "https://github.com/remcohaszing/pywakeonlan/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}

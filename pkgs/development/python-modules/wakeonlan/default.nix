{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    tag = version;
    hash = "sha256-AQjecGfcxI+zzUR6IO/iG/49QH1jClNYJFBEOABek5U=";
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

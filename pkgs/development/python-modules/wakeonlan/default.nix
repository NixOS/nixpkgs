{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wakeonlan";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    tag = finalAttrs.version;
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
    changelog = "https://github.com/remcohaszing/pywakeonlan/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})

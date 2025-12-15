{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = "whisper";
    tag = version;
    hash = "sha256-CnCbRmI2jc67mTtfupoE1uHtobrAiWoUXbfX8YeEV6A=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # whisper-resize.py: not found
    "test_resize_with_aggregate"
  ];

  pythonImportsCheck = [ "whisper" ];

  meta = {
    homepage = "https://github.com/graphite-project/whisper";
    description = "Fixed size round-robin style database";
    changelog = "https://graphite.readthedocs.io/en/latest/releases/${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }.html";
    maintainers = with lib.maintainers; [
      offline
      basvandijk
    ];
    license = lib.licenses.asl20;
  };
}

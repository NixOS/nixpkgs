{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = pname;
    tag = version;
    hash = "sha256-CnCbRmI2jc67mTtfupoE1uHtobrAiWoUXbfX8YeEV6A=";
  };

  propagatedBuildInputs = [ six ];

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
    maintainers = with lib.maintainers; [
      offline
      basvandijk
    ];
    license = lib.licenses.asl20;
  };
}

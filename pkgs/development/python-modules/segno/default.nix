{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # tests
  pytestCheckHook,
  pypng,
  pyzbar,
}:

buildPythonPackage rec {
  pname = "segno";
  version = "1.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "heuer";
    repo = "segno";
    tag = version;
    hash = "sha256-A6lESmVogypit0SDeG4g9axn3+welSqTt1A17BNLmvU=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pypng
    pyzbar
  ];

  disabledTests = [
    # https://github.com/heuer/segno/issues/132
    "test_plugin"
  ];

  pythonImportsCheck = [ "segno" ];

  meta = {
    changelog = "https://github.com/heuer/segno/releases/tag/${src.tag}";
    description = "QR Code and Micro QR Code encoder";
    mainProgram = "segno";
    homepage = "https://github.com/heuer/segno/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phaer ];
  };
}

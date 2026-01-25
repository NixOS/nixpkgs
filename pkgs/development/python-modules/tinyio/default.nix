{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tinyio";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "tinyio";
    tag = "v${version}";
    hash = "sha256-zAmsUe1fQeTxv0U++lU6abaP8YQMLlF3rkI7eyhTK0I=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [ "tinyio" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError
    # assert 0 >= 4, where 0 = sum([False, False, False, False, False])
    "test_sleep"
  ];

  meta = {
    description = "Dead-simple event loop for Python";
    homepage = "https://github.com/patrick-kidger/tinyio";
    changelog = "https://github.com/patrick-kidger/tinyio/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  maturin,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "uuid-utils";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aminalaee";
    repo = "uuid-utils";
    tag = version;
    hash = "sha256-vHezizqhVS6vHowX7231ZJtmEDOp8PG4KtJgSwevqWM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-MG2IonqvB+G8Vz+fHls/F8sUEGhXO2nA4a027yhfrCk=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  build-system = [
    maturin
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError comparing node numbers
    # https://github.com/aminalaee/uuid-utils/issues/99
    "test_getnode"
  ];

  pythonImportsCheck = [
    "uuid_utils"
  ];

  meta = {
    description = "Python bindings to Rust UUID";
    homepage = "https://github.com/aminalaee/uuid-utils";
    changelog = "https://github.com/aminalaee/uuid-utils/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}

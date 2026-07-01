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
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aminalaee";
    repo = "uuid-utils";
    tag = version;
    hash = "sha256-5pGBc1+2Vx0nIwhLFBy/Mx5GLLzA7Oj4eWPPCfBV1v4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-o9fmecoYGu+UR0/Km6sGq5buVo8qHKnBSuvvfogmkx0=";
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

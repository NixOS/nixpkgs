{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  maturin,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "uuid-utils";
  version = "0.17.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aminalaee";
    repo = "uuid-utils";
    tag = finalAttrs.version;
    hash = "sha256-AshQOXB6o1CMByRn9um8E2Y4sexyRu4W8H3NelFe1HM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-vf6w+oYH3tdxvV5TLSgZOAXlFypCe2swjkw25VWCqB8=";
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
    changelog = "https://github.com/aminalaee/uuid-utils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})

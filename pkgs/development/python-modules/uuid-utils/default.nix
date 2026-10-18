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
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aminalaee";
    repo = "uuid-utils";
    tag = finalAttrs.version;
    hash = "sha256-NzipRczC2NSNQm7aA9eVTNP1KToFbXGllyuSi7wlC9o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-khea+XMxNDkWaRVYgRdFQqABVoL3uSpRKMrM7BlE/B4=";
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

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
  version = "1.0.0a2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aminalaee";
    repo = "uuid-utils";
    tag = version;
    hash = "sha256-NoN1JzarU/s4jR3lx2YiImNv3zGgxm/2Nce4s9mVX/Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-iYYYfPL4afHDAAEFmzwe7oFnnJH/cdf9NLWUB07YdhU=";
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  libiconv,
  buildPythonPackage,
  setuptools,
  setuptools-rust,
  pytestCheckHook,
  pytest-mypy-plugins,
  pytest-order,
  hypothesis,
  freezegun,
  time-machine,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "whenever";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "whenever";
    tag = version;
    hash = "sha256-oSrHu2DicPWg1x1hpq1vHhVQ/3Fsc17zNMuwsGAYo/E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-ZJhHIY9oFGGfK0XdZtzH7uSqbg3y3aDEh5q4ba5W0tI=";
  };

  build-system = [
    setuptools
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy-plugins
    pytest-order
    # pytest-benchmark # developer sanity check, should not block distribution
    hypothesis
    freezegun
    time-machine
  ];

  disabledTestPaths = [
    # benchmarks need pytest-benchmark, a developer sanity check only
    "benchmarks"
  ];

  disabledTests = [
    # runs `python -I`, which ignores the test PYTHONPATH, so `whenever` is not
    # importable in the sandbox
    "test_import_does_not_load_typing_extensions"
  ];

  pythonImportsCheck = [ "whenever" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Strict, predictable, and typed datetimes";
    homepage = "https://github.com/ariebovenberg/whenever";
    changelog = "https://github.com/ariebovenberg/whenever/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}

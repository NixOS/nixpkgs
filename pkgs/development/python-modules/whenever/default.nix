{
  lib,
  stdenv,
  fetchFromGitHub,
  pythonOlder,
  rustPlatform,
  cargo,
  rustc,
  libiconv,
  buildPythonPackage,
  setuptools,
  setuptools-rust,
  pytestCheckHook,
  pytest-mypy-plugins,
  hypothesis,
  freezegun,
  time-machine,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "whenever";
  version = "0.8.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "whenever";
    tag = version;
    hash = "sha256-i9zUf0oRcG4993Q0kkfndfcEe+mLYFcqrIlg7idKDGY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-j4sxIcJa406HCDkTJCSU8H+yo2Jth1p8+CaNWlUaIUs=";
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
    # pytest-benchmark # developer sanity check, should not block distribution
    hypothesis
    freezegun
    time-machine
  ];

  disabledTestPaths = [
    # benchmarks
    "benchmarks/python/test_date.py"
    "benchmarks/python/test_instant.py"
    "benchmarks/python/test_local_datetime.py"
    "benchmarks/python/test_zoned_datetime.py"
  ];

  pythonImportsCheck = [ "whenever" ];

  # a bunch of failures, including an assumption of what the timezone on the host is
  # TODO: try enabling on bump
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Strict, predictable, and typed datetimes";
    homepage = "https://github.com/ariebovenberg/whenever";
    changelog = "https://github.com/ariebovenberg/whenever/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}

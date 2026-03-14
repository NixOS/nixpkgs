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
  hypothesis,
  freezegun,
  time-machine,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "whenever";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "whenever";
    tag = version;
    hash = "sha256-HGASKQHQWXPzMcTHylRG94ZdL2gwLyHyfoTywllMTdA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-i5hbXk+CFrsnIhT3DjnWbP2GaIqJxll8fbxCFz/21M8=";
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

  meta = {
    description = "Strict, predictable, and typed datetimes";
    homepage = "https://github.com/ariebovenberg/whenever";
    changelog = "https://github.com/ariebovenberg/whenever/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}

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
}:

buildPythonPackage rec {
  pname = "whenever";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "whenever";
    rev = "refs/tags/${version}";
    hash = "sha256-uUjQtaqPO/Ie7vVddQhc3dxORX2PxNRaDJzCr+vieUo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-8U3pGKY9UQ0JpzUn3Ny6YSD3wzXPDi1pupD5fpEJFvw=";
  };

  build-system = [
    setuptools
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy-plugins
    # pytest-benchmark # developer sanity check, should not block distribution
    hypothesis
    freezegun
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

  meta = with lib; {
    description = "Strict, predictable, and typed datetimes";
    homepage = "https://github.com/ariebovenberg/whenever";
    changelog = "https://github.com/ariebovenberg/whenever/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}

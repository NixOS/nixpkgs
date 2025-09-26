{
  lib,
  buildPythonPackage,
  fetchPypi,
  maturin,
  pythonOlder,
  rustPlatform,
  rustc,
  cargo,
  semantic-version,
  setuptools,
  setuptools-rust,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "1.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "setuptools_rust";
    inherit version;
    hash = "sha256-2UqT8Ml3UcFwFFZfB73DJL7kXTls0buoPY56+SuUXww=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    semantic-version
    setuptools
  ];

  pythonImportsCheck = [ "setuptools_rust" ];

  doCheck = false;

  passthru.tests = {
    pyo3 = maturin.tests.pyo3.override {
      format = "setuptools";
      buildAndTestSubdir = null;

      nativeBuildInputs = [
        setuptools-rust
      ]
      ++ [
        rustPlatform.cargoSetupHook
        cargo
        rustc
      ];

      preConfigure = ''
        # sourceRoot puts Cargo.lock in the wrong place due to the
        # example setup.
        cd examples/word-count
      '';
    };
  };

  meta = with lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    changelog = "https://github.com/PyO3/setuptools-rust/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}

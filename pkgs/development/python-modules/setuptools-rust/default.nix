{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  maturin,
  rustPlatform,
  rustc,
  cargo,
  semantic-version,
  setuptools,
  setuptools-rust,
  setuptools-scm,
  replaceVars,
  python,
  targetPackages,
}:
buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "1.12.0";
  pyproject = true;

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

  # integrate the setup hook to set up the build environment for cross compilation
  # this hook is automatically propagated to consumers using setuptools-rust as build-system
  #
  # Only include the setup hook if python.pythonOnTargetForTarget is not empty.
  # python.pythonOnTargetForTarget is not always available, for example in
  # pkgsLLVM.python3.pythonOnTargetForTarget. cross build with pkgsLLVM should not be affected.
  setupHook =
    if python.pythonOnTargetForTarget == { } then
      null
    else
      replaceVars ./setuptools-rust-hook.sh {
        pyLibDir = "${python.pythonOnTargetForTarget}/lib/${python.pythonOnTargetForTarget.libPrefix}";
        cargoBuildTarget = stdenv.targetPlatform.rust.rustcTargetSpec;
        cargoLinkerVar = stdenv.targetPlatform.rust.cargoEnvVarTarget;
        targetLinker = "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc";
      };

  passthru.tests = {
    pyo3 = maturin.tests.pyo3.override {
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

  meta = {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    changelog = "https://github.com/PyO3/setuptools-rust/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

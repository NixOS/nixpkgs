{ callPackage
, rustPlatform
, setuptools-rust
}:

callPackage ../../../tools/rust/maturin/pyo3-test/generic.nix {
  # Isolated builds break for this package, because PyO3 is not
  # in the build root of the Python Package:
  #
  # https://github.com/pypa/pip/issues/6276
  #
  format = "setuptools";

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  sourceRoot = "source/examples/word-count";
}

{
  callPackage,
  cargo,
  rustPlatform,
  rustc,
  setuptools-rust,
}:

callPackage ../../../tools/rust/maturin/pyo3-test/generic.nix {
  # Isolated builds break for this package, because PyO3 is not
  # in the build root of the Python Package:
  #
  # https://github.com/pypa/pip/issues/6276
  #
  format = "setuptools";

  nativeBuildInputs =
    [ setuptools-rust ]
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
}

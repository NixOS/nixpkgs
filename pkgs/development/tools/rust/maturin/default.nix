{ callPackage
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-uaDTL6dfH+zqjMbLtgLaZRe91mDuyKA0afw+3LFF+1U=";
  };

  cargoHash = "sha256-DF8O3YrHr0tBStnmnUUUF4QaZcoXYCCweZoEig4etQA=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  # Requires network access, fails in sandbox.
  doCheck = false;

  passthru.tests.pyo3 = callPackage ./pyo3-test {};

  meta = with lib; {
    description = "Build and publish Rust crates Python packages";
    longDescription = ''
      Build and publish Rust crates with PyO3, rust-cpython, and
      cffi bindings as well as Rust binaries as Python packages.

      This project is meant as a zero-configuration replacement for
      setuptools-rust and Milksnake. It supports building wheels for
      Python and can upload them to PyPI.
    '';
    homepage = "https://github.com/PyO3/maturin";
    changelog = "https://github.com/PyO3/maturin/blob/v${version}/Changelog.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ ];
  };
}

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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-DXPhe6QI1IEPA/Y+qDMu92i18uhXCN0VVJpCoAIDs4c=";
  };

  cargoHash = "sha256-3K131d7bDvfmAhYWFNyY+qwi7F8vKk3kw4L+fM0LKMo=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  # Requires network access, fails in sandbox.
  doCheck = false;

  passthru.tests.pyo3 = callPackage ./pyo3-test {};

  meta = with lib; {
    description = "Build and publish Rust crates Python packages";
    mainProgram = "maturin";
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

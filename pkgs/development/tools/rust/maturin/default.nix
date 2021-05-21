{ callPackage
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, dbus
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-wI5bk9LauIfT4aEo1pCtUicXn0mJb4ijqV0NI6rKL6k=";
  };

  cargoHash = "sha256-xLT3QeLDZnPrW1rCa0E1DrCYiqhb04o3vdi8pdJdWJQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optional stdenv.isLinux dbus
    ++ lib.optional stdenv.isDarwin Security;

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
    license = licenses.asl20;
    maintainers = [ maintainers.danieldk ];
  };
}

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
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-9emrBajFd0eLHcsd9Uf6MLCWqZFqxmZdWPBLGIYc2kU=";
  };

  cargoSha256 = "113i7a5hpz7qch45wwapp53ixvgssnlxm0810yjicxp3k61ak30j";

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

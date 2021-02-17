{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, dbus
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-3Tir9jvpSgjyF5tEn3xpPcpSATEnn9yaWIKE8hZIdsM=";
  };

  cargoHash = "sha256-o0+ZlGnnVUJiTqIdioj+geiP6PWz/AKCXhx+/TgKmqs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optional stdenv.isLinux dbus
    ++ lib.optional stdenv.isDarwin Security;

  # Requires network access, fails in sandbox.
  doCheck = false;

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

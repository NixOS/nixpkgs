{ callPackage
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, dbus
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-UH+qOKKQdWXQZZMtrihbWmKaUoSy1NciGh9UTtS/W5E=";
  };

  cargoHash = "sha256-EGgVPRaofia+AwXSr6X4Aa8jbk5qDkXg1XvMoEp0qMQ=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ dbus ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv ];

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

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
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-jWkrjFQg0EqM+e/IT2n2E4lGL2kT/Wz7r5BLlzvWSO0=";
  };

  cargoHash = "sha256-+kXwMGeE2HD59EU0Dzvg8I6LcHiPV7SKSFqnCTfkKwY=";

  nativeBuildInputs = [ pkg-config ];

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
    license = licenses.asl20;
    maintainers = [ ];
  };
}

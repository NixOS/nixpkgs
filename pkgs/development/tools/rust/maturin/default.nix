{ callPackage
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
<<<<<<< HEAD
=======
, pkg-config
, dbus
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
<<<<<<< HEAD
  version = "1.2.2";
=======
  version = "0.14.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uaDTL6dfH+zqjMbLtgLaZRe91mDuyKA0afw+3LFF+1U=";
  };

  cargoHash = "sha256-DF8O3YrHr0tBStnmnUUUF4QaZcoXYCCweZoEig4etQA=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];
=======
    hash = "sha256-Qvk9Pde1xmQ/lqU6KCda+F6UV7b414TDswP5Cwrh4jc=";
  };

  cargoHash = "sha256-mPpM8jVDA9TbdNR1AdAzVP6sd2glUpDKhyVaaCcQzKE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ dbus ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    changelog = "https://github.com/PyO3/maturin/blob/v${version}/Changelog.md";
    license = with licenses; [ asl20 /* or */ mit ];
=======
    license = licenses.asl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ ];
  };
}

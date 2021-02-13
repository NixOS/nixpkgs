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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-0HD/wtHCbaJ0J+TC6k2xvWsCMnpdJbvivW/UM3g+Gss=";
  };

  cargoHash = "sha256-bH9NQg7wJUe0MHkbt4DbjZEEVYZiVCwSbL4A/H+6WDs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optional stdenv.isLinux dbus
    ++ lib.optional stdenv.isDarwin Security;

  # Requires network access, fails in sandbox.
  doCheck = false;

  meta = with lib; {
    description = "Build and publish crates with pyo3 bindings as python packages";
    homepage = "https://github.com/PyO3/maturin";
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
  };
}

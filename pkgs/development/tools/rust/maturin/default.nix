{ stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkgconfig
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "maturin-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    sha256 = "16bxxa261k2l6mpdd55gyzl1mx756i0zbvqp15glpzlcwhb9bm2m";
  };

  cargoSha256 = "1s1brfnhwl42jb37qqz4d8mxpyq2ck60jnmjfllkga3mhwm4r8px";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gmp openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional stdenv.isLinux dbus;

  # Requires network access, fails in sandbox.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Build and publish crates with pyo3 bindings as python packages";
    homepage = "https://github.com/PyO3/maturin";
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.all;
  };
}

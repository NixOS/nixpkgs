{ lib, stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkg-config
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "maturin-${version}";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    sha256 = "08l5r7d75id6qzf8xhkjv4hkdr64cq4dbcmdjywmvf9szjbnr65z";
  };

  cargoSha256 = "1n0sxkhcdg2rbzqd7826pa7sxlnn0c2sc8l6lc98xw21vvqisc8n";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gmp openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional stdenv.isLinux dbus;

  # Requires network access, fails in sandbox.
  doCheck = false;

  meta = with lib; {
    description = "Build and publish crates with pyo3 bindings as python packages";
    homepage = "https://github.com/PyO3/maturin";
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
  };
}

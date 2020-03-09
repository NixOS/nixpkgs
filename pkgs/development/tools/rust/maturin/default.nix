{ stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkgconfig
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "maturin-${version}";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    sha256 = "1siqd8k6grlbj9n1a75jq8px1pzvzpr2ph689g53rjngf1k44zqk";
  };

  cargoSha256 = "10x8kr4qxvvmzpr1n41ybsb6rnii2qz5bdhnk0zpfnr2n9215p8s";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gmp openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional stdenv.isLinux dbus;

  # Requires network access, fails in sandbox.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Build and publish crates with pyo3 bindings as python packages";
    homepage = https://github.com/PyO3/maturin;
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.all;
  };
}

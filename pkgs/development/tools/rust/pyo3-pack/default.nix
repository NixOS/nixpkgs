{ stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkgconfig
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "pyo3-pack-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "pyo3-pack";
    rev = "v${version}";
    sha256 = "0577v8nqjbb7l7fqvac706bg9zrcp8fbh9ca1mkj44db12v02kgb";
  };

  cargoSha256 = "1xrzz8c2pfb70i7ynv5lw0d89r284kvhkgjh8z8pgyk1j79ixv2v";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gmp openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security
    ++ stdenv.lib.optional stdenv.isLinux dbus;

  # Requires network access, fails in sandbox.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Build and publish crates with pyo3 bindings as python packages";
    homepage = https://github.com/PyO3/pyo3-pack;
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.all;
  };
}

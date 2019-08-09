{ stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkgconfig
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "pyo3-pack-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "pyo3-pack";
    rev = "v${version}";
    sha256 = "0zk0jhr7lnl9z6c8pbk7si3wa8b1kqzj3wrslc1n5fjla7xx8fzn";
  };

  cargoSha256 = "13gycipxc17baxg8nvjzkw96i1pxgncx7qjcrm9aab7p9vi2vrih";

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

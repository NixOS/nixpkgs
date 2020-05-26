{ stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkgconfig
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "maturin-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    sha256 = "1fjai0c0j8zzaj4c186dkbvx6cpj0vi3sc1qbjbgn2cm8azsd6m6";
  };

  # The maturin 0.8.0 lockfile has an incorrect version for maturin
  # itself. The upstream lockfiles are normally correct, so this
  # should be removed post-0.8.0.
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoSha256 = "01sh523fi46k5xwdslhnmjz128jkdw47gp9bd8gim3ay13zkcn1i";

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

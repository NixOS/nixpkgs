{ stdenv, fetchFromGitHub, rustPlatform, dbus, gmp, openssl, pkgconfig
, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rustPlatform.buildRustPackage rec {
  name = "pyo3-pack-${version}";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "pyo3-pack";
    rev = "v${version}";
    sha256 = "14343209w7wphkqh7pnw08pah09spjbwhk6l548g9ivra057gwaz";
  };

  cargoSha256 = "0n7z9p3v92ijqc2ix60wi74as5rql61k5qbqi8b1b02b71xmsp7j";

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

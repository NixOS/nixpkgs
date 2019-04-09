{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = pname;
    rev = version;
    sha256 = "1hsncyidzh41fmrb29f8n7k5ij28wh8b74j8wa1ikimsvzpqya6p";
  };

  cargoSha256 = "18jmk6fk59qvxb34ia8vxww09p616a2c3nxs981sl65p84fvlgrp";
  cargoPatches = [ ./fix-build.patch ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also: https://travis-ci.org/sagiegurari/cargo-make/builds/515874289
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = https://github.com/sagiegurari/cargo-make;
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}

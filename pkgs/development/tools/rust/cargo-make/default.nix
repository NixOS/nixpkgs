{ lib, stdenv, fetchurl, runCommand, fetchCrate, rustPlatform, Security, openssl, pkg-config
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.32.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-cDpEFw9uICB/4aZheTWwDqYGjLz+C6gLie/S3ehhifg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoSha256 = "sha256-Qh14lks72bsetwyv0ALF7nZo3m3FDEmVxzFkHJoEuzE=";

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ma27 ];
  };
}

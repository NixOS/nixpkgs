{ lib
, stdenv
, fetchurl
, runCommand
, fetchCrate
, rustPlatform
, Security
, openssl
, pkg-config
, SystemConfiguration
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.35.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YNPAIdN9FDUHs/5aCYJN+1/12ZYk1YJsUjjB1a09KvA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoSha256 = "sha256-xLFBF8fEbupLgFNdYC1NzM6p7O2gvsv0Utk4Et2oBDc=";

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

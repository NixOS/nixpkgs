{ stdenv, fetchurl, runCommand, fetchCrate, rustPlatform, Security, openssl, pkg-config
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.32.9";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0f6avprq0d65v5fk3kn2kvw3w024f21yq6v8y7d9rbwqxxf87jlf";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoSha256 = "0v0657hh8ivqaq4sn0saaiz06shxavhrh9mksjlzj7c2ym6cxkih";

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ma27 ];
  };
}

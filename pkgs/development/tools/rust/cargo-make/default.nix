{ stdenv, fetchurl, runCommand, fetchCrate, rustPlatform, Security, openssl, pkg-config
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.32.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-TwutU4RjiYtxc2vT67Bgqe/WRHi5aXwgzvZu7Wk4Cao=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoSha256 = "sha256-HzRriPVaMn6qDu6h/NQjILglO4/0//8J1orV4Uz+XEI=";

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

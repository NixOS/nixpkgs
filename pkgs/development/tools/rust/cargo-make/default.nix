{ stdenv, fetchurl, runCommand, fetchCrate, rustPlatform, Security, openssl, pkg-config
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.32.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0qcwhmba83rrwqnlkcmvnmbj9jb2bwm0mka8rcp26y4yxmjm431n";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoSha256 = "1dmcdzdm7kzmrq2xsiaikns2xzjpdmh9w8pw653nlqfjjr2h6pxp";

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

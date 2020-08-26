{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.32.2";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "0l0pislc7pgx1m68kirvadraq88c86mm1k46wbz3a47ph2d4g912";
      };
    in
    runCommand "source" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoSha256 = "16ygkh8sbb37nfc41shxg9nh2mbszyschbqrrr1gr7xzf1z36ipp";

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

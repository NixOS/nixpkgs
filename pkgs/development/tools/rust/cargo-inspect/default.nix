{ stdenv, lib, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-inspect";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "mre";
    repo = pname;
    rev = version;
    sha256 = "0rjy8jlar939fkl7wi8a6zxsrl4axz2nrhv745ny8x38ii4sfbzr";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1pxvcf991w0jfxdissvwal5slrx7vpk3rqkzwk4hxfv0mjiqxsg5";

  meta = with lib; {
    description = "See what Rust is doing behind the curtains";
    homepage = https://github.com/mre/cargo-inspect;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
  };
}

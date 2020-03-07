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

  cargoSha256 = "0v7g9rkw7axy99vcfi7sy2pw7wnpq424jvd8xchcv8ghh8yw9lyc";

  meta = with lib; {
    description = "See what Rust is doing behind the curtains";
    homepage = https://github.com/mre/cargo-inspect;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
  };
}

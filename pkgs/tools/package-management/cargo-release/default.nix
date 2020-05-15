{ stdenv, rustPlatform, fetchFromGitHub, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "0d9fgmy87xjl9kcmx9crmmg83iyybisg0gfwmnlxz5529slqng5r";
  };

  cargoSha256 = "1a6ac4x51i1rg0bgrxbbdd54gmwldsiv7nn8vi81y20llnshgjk7";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}

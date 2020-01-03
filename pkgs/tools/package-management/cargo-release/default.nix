{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "02rx25dd3klprwr1qmn5vn4vz4244amk2ky4nqfmi4vq3ygrhd1c";
  };

  cargoSha256 = "18nbmq8j58jlka1lsrx2y0bhb9l5f3wyvcr1zmmda3hvc3vm7kla";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = https://github.com/sunng87/cargo-release;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}

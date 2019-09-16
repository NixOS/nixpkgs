{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = version;
    sha256 = "14l5znr1nl69v2v3mdrlas85krq9jn280ssflmd0dz7i4fxiaflc";
  };

  cargoSha256 = "1l1rvd3i3d7jn3crwc194i5qm3f0jaw7ksb4bvqn3v8rf44chmrs";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = https://github.com/sunng87/cargo-release;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}

{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  name = "cargo-release-${version}";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "${version}";
    sha256 = "14l5znr1nl69v2v3mdrlas85krq9jn280ssflmd0dz7i4fxiaflc";
  };

  cargoSha256 = "1f0wgggsjpmcijq07abm3yw06z2ahsdr9iwn4izljvkc1nkqk6jq";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = https://github.com/sunng87/cargo-release;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}

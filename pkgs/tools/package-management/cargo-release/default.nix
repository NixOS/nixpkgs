{ stdenv, rustPlatform, fetchFromGitHub, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "0w4p1v9ya6kai2sy4ic45s1m01ya3hlysxlc8ha698jfvzs8nnld";
  };

  cargoSha256 = "02x268xbxd2nin9y1dm35mkk90vyx16zzp18fi4fwc8kpsdbjpai";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = https://github.com/sunng87/cargo-release;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}

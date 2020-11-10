{ stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.13.8";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "16v93k8d1aq0as4ab1i972bjw410k07gb3s6xdzb1r019gxg2i2h";
  };

  cargoSha256 = "1jbp8jbpxnchzinjzv36crszdipxp1myknmrxn7r0ijfjdpigk9r";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
  };
}

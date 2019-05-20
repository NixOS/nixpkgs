{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "unstable-2019-04-13";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "ce4b6baddc94b77a155abbb5a4fa4d3b31a45598";
    sha256 = "0x00vn0ldnm2hvndfmq4g4q5w6axyg9vsri3i5zxhmir7423xabp";
  };

  cargoSha256 = "1xqii2z0asgkwn1ny9n19w7d4sjz12a6i55x2pf4cfrciapdpvdl";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = https://github.com/kbknapp/cargo-outdated;
    license = with licenses; [ asl20 /* or */ mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.sondr3 ];
  };
}

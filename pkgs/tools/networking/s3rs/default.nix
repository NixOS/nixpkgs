{ lib, stdenv, rustPlatform, python3, perl, openssl, Security, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "s3rs";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "yanganto";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lYIE5yR7UNUjpqfwT6R0C0ninNvVZdatYd/n+yyGsms=";
  };

  cargoSha256 = "sha256-vCTJ7TClvuIP9IoqXwNFH7/u9jXt/Ue/Dhefx5rCgmA=";

  nativeBuildInputs = [ python3 perl pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A s3 cli client with multi configs with diffent provider";
    homepage = "https://github.com/yanganto/s3rs";
    license = licenses.mit;
    maintainers = with maintainers; [ yanganto ];
  };
}

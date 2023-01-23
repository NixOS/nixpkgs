{ lib, stdenv, rustPlatform, python3, perl, openssl, Security, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "s3rs";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "yanganto";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-n95ejw6EZ4zXzP16xFoUkVn1zIMcVgINy7m5NOz063A=";
  };

  cargoSha256 = "sha256-eecQi03w7lq3VAsv9o+3kulwhAXPoxuDPMu/ZCQEom4=";

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

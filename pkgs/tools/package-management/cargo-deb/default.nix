{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.23.2";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "367910e0020de93f45c175c92a37a53ee401978f";
    sha256 = "1s0xv818rlafdzpb70c1ldv5iq3hh2jxj7g3l6p7v20q1wx0nnvv";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0ffzq2gm0f56vyfkmdzxfs5z1xsdj2kcsyc1fdrk4k1cylqn2f47";

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}

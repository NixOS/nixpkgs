{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rates";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lunush";
    repo = pname;
    rev = version;
    sha256 = "sha256-ivJ6rD4+EYeMg6nOWzf3lp521+7NTBq5vCn7648q0T8=";
  };

  cargoSha256 = "sha256-dsWAxYFB096SZN5tfzEMokdQ8qw1aR/6Hmjtkdw1L8E=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "CLI tool that brings currency exchange rates right into your terminal";
    homepage = "https://github.com/lunush/rates";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

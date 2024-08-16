{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rates";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lunush";
    repo = pname;
    rev = version;
    sha256 = "sha256-zw2YLTrvqbGKR8Dg5W+kJTDKIfro+MNyjHXfZMXZhaw=";
  };

  cargoHash = "sha256-5EcTeMfa1GNp1q60qSgEi/I3298hXUD1Vc1K55XGW4I=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "CLI tool that brings currency exchange rates right into your terminal";
    homepage = "https://github.com/lunush/rates";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "rates";
  };
}

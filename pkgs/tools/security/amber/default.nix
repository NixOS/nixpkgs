{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  # Renaming it to amber-secret because another package named amber exists
  pname = "amber-secret";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "amber";
    rev = "v${version}";
    sha256 = "1l5c7vdi885z56nqqbm4sw9hvqk3rfzm0mgcwk5cbwjlrz7yjq4m";
  };

  cargoSha256 = "0dmhlyrw6yd7p80v7anz5nrd28bcrhq27vzy605dinddvncjn13q";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Manage secret values in-repo via public key cryptography";
    homepage = "https://github.com/fpco/amber";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
    mainProgram = "amber";
  };
}

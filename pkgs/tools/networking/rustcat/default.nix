{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rustcat";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aoeinz1XVJ+MNt8ndV/HnKLdwa7rXwxIZucCkZCnNaM=";
  };

  cargoSha256 = "sha256-cQxBM8m0sy9WKvKqyY/sNE3p4l2v9zdx80mReQEAoc8=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Port listener and reverse shell";
    homepage = "https://github.com/robiot/rustcat";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "rcat";
  };
}

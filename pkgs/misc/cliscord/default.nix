{
  lib,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cliscord";
  version = "unstable-2022-10-07";

  src = fetchFromGitHub {
    owner = "somebody1234";
    repo = pname;
    rev = "d62317d55c07ece8c9d042dcd74b62e58c9bfaeb";
    hash = "sha256-dmR49yyErahOUxR9pGW1oYy8Wq5SWOprK317u+JPBv4=";
  };

  buildInputs = [ openssl ] ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-Z8ras6W4BnAWjHe6rPd1X1d3US5gq7CxnBAkW//OTsg=";

  meta = with lib; {
    description = "Simple command-line tool to send text and files to discord";
    homepage = "https://github.com/somebody1234/cliscord";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    mainProgram = "cliscord";
  };
}

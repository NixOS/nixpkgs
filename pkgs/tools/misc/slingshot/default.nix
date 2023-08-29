{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "slingshot";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "caio-ishikawa";
    repo = "slingshot";
    rev = "v${version}";
    hash = "sha256-PbcpvSBYoRs8TMkbbQjG284BWr+PSaTStPOg4a1GIrw=";
  };

  cargoHash = "sha256-Y0H88paBe2yyUyTdwxXO58YFDdH04kK+nHvi1qyYVF0=";

  meta = with lib; {
    description = "Lightweight command line tool to quickly navigate across folders";
    homepage = "https://github.com/caio-ishikawa/slingshot";
    changelog = "https://github.com/caio-ishikawa/slingshot/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "slingshot";
  };
}

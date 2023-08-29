{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    rev = "47dd0132b12661ab6c97f5fba892e567a5109c84";
    hash = "sha256-aV3QAp6DkNrHiDe1Ytiu6UyTWrelV6vO83Baiv4ONLg=";
  };

  cargoHash = "sha256-9d/KiQ7IXhmYvTb97FKJh/cGTdnxAgCXSx4+V74b+RE=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [ "-p=postgres_lsp" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "A Language Server for Postgres";
    homepage = "https://github.com/supabase/postgres_lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "postgres_lsp";
  };
}

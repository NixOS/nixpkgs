{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "unstable-2024-01-11";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    rev = "bbc24cc541cd1619997193ed81ad887252c7e467";
    hash = "sha256-llVsHSEUDRsqjSTGr3hGUK6jYlKPX60rpjngBk1TG2Y=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Npx/sSbMr4PKnNPslvjpOyKH0bpQLzW6cLNW+7H/TQ0=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [ "-p=postgres_lsp" ];
  cargoTestFlags = cargoBuildFlags;

  RUSTC_BOOTSTRAP = 1; # We need rust unstable features

  meta = with lib; {
    description = "A Language Server for Postgres";
    homepage = "https://github.com/supabase/postgres_lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "postgres_lsp";
  };
}

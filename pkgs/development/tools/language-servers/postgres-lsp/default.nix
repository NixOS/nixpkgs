{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "unstable-2023-10-20";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    rev = "88901a987de9a2d8db05c36bcd87c5c877b51460";
    hash = "sha256-HY83SO2dlXKamIqFEz53A8YDYx9EynX8FCX9EjF+tdw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-m8m0Q3UAq6kV2IoXMFTkP0WKzSXiWPkfOkta639dcj0=";

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

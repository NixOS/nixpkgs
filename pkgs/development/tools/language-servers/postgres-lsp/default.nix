{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    rev = "1250f5ed14a0e86b2b7fa581214284c67b960621";
    hash = "sha256-Y43sTgKNcAI3h6McDc0g6o9CX6jOKBfURLWyjJhvmwk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  # Cargo.lock is ignored
  # https://github.com/supabase/postgres_lsp/pull/28
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

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

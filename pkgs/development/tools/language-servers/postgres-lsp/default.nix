{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "0-unstable-2024-03-24";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    rev = "43ca9b675cb152ca7f38cfa6aff6dd2131dfa9a2";
    hash = "sha256-n7Qbt9fGzC0CcleAtTWDInPz4oaPjI+pvIPrR5EYJ9U=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-UEcHlkbYMA6xETMryWXsDHyAZYtLncRJn2jA6tvw7gQ=";

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

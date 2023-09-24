{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "postgres-lsp";
  version = "unstable-2023-09-21";

  src = (fetchFromGitHub {
    owner = "supabase";
    repo = "postgres_lsp";
    rev = "f25f23a683c4e14dea52e3e423584588ab349081";
    hash = "sha256-z8WIUfgnPYdzhBit1V6A5UktjoYCblTKXxwpbHOmFJA=";
    fetchSubmodules = true;
  }).overrideAttrs {
    # workaround to be able to fetch git@github.com submodules
    # https://github.com/NixOS/nixpkgs/issues/195117
    env = {
      GIT_CONFIG_COUNT = 1;
      GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
      GIT_CONFIG_VALUE_0 = "git@github.com:";
    };
  };

  cargoHash = "sha256-Nyxiere6/e5Y7YcgHitVkaiS1w3JXkbohIcBNc00YXY=";

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

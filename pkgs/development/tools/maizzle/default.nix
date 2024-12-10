{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "maizzle";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "maizzle";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-cSAYicgCgFpJO+2vBAqfl3od7B07DTXvkW38x6y5VgM=";
  };

  npmDepsHash = "sha256-K9EQxqOjFzgTw/VXG2ZGF90yUzYTNl13Ssq9oiC+F7A=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for the Maizzle Email Framework";
    homepage = "https://github.com/maizzle/cli";
    license = lib.licenses.mit;
    mainProgram = "maizzle";
    maintainers = with lib.maintainers; [ happysalada ];
  };
}

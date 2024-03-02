{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-AMnUErmufHc05MxHru/b4mFHH+HF9jfhoNi8yIejc64=";
  };

  cargoHash = "sha256-flMzNxA1NWGy4ea7/dmPiEKspBmVuy82VPe5r8jaEGg=";

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Experimental JSONPath engine for querying massive streamed datasets";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rq";
  };
}

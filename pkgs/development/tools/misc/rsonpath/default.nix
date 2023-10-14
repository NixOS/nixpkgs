{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-gAoxWdczeaN4VqeQY0qJeLK8aABGhuwXf41QFKUxAG0=";
  };

  cargoHash = "sha256-UXPVqc4RNIFKx0f/BPCfkJxilioXbRZSAgqQv1MzK7k=";

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

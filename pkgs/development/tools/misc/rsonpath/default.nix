{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-g6dBPW3iIRslzQUwcmx9Ube/Q3llp6Sstdihq9ExANU=";
  };

  cargoHash = "sha256-byeMX4wKFQbOH9f89cWkrpKAbhThLlR12Xok7vn/hOw=";

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

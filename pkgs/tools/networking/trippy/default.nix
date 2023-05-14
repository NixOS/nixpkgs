{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-ABdG1FKgFF/vMkAQl2tk8FcnSzC4Z3r9E67ZwAGPt8U=";
  };

  cargoHash = "sha256-1H3JHZbG8k15Qfpsk+XykmbotHcO+J4zTbwdlOR2kso=";

  meta = with lib; {
    description = "A network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}

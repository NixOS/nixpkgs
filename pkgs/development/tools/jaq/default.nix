{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    hash = "sha256-QXlHiVlKx9qmW5Cw4IGzjuUSUfoc9IvA5ZkTc1Ev37Q=";
  };

  cargoHash = "sha256-9fv8Z9AE9GV/Bq+iAsxUkD/CS25/kOBKKS4SAke/tFk=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      siraben
    ];
    mainProgram = "jaq";
  };
}

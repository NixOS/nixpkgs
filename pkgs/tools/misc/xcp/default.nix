{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RxEEbyM7wXteYteA4GmvXEraHhm+Kkr2UbYR8G0gO8c=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-ruL1KP3a76DRg0RqpNYz0ZL0V2Ce4v3zt9B/tXyXQs0=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}

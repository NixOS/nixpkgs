{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "funzzy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "cristianoliveira";
    repo = "funzzy";
    rev = "v${version}";
    hash = "sha256-Vfx/AJTeMM5GwIhDTqoteVIdr7tx4tea7SKAczauUjo=";
  };

  cargoHash = "sha256-uOhlx38URy7+LqYhUi/hRtfr84visq0wqCU3qm42IKo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A lightweight watcher";
    homepage = "https://github.com/cristianoliveira/funzzy";
    changelog = "https://github.com/cristianoliveira/funzzy/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

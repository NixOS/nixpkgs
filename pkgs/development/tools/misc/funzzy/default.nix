{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "funzzy";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "cristianoliveira";
    repo = "funzzy";
    rev = "v${version}";
    hash = "sha256-sgfMxSbOBn2Ps6hqrFDm3x9QOnMvtMgO7gAt6kk0cIs=";
  };

  cargoHash = "sha256-If8iBvwiaH1jK8z06ORY/lx+7HAT4InxbjoLe289kws=";

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

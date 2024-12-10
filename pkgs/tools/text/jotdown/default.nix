{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-Q1BjmcA5otOkeEe8KQiqKGKHSeGntj+ktcNMrdbGHZI=";
  };

  cargoHash = "sha256-bkMJ7ApM+GsshwIFuYsH19CnU6ebq0GfwQvVp9QD46A=";

  meta = with lib; {
    description = "A minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "peep";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ryochack";
    repo = "peep";
    rev = "v${version}";
    hash = "sha256-6Y7ZI0kIPE7uMMOkXgm75JMEec090xZPBJFJr9DaswA=";
  };

  cargoHash = "sha256-CDWa03H8vWfhx2dwZU5rAV3fSwAGqCIPcvl+lTG4npE=";

  meta = with lib; {
    description = "The CLI text viewer tool that works like less command on small pane within the terminal window";
    homepage = "https://github.com/ryochack/peep";
    changelog = "https://github.com/ryochack/peep/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "peep";
  };
}

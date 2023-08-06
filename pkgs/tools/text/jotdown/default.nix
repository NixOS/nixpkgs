{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-UnrX6T5pjrxHE5feW287613vX5uqkdeFw2F14evzfmk=";
  };

  cargoHash = "sha256-tbyDCJvTVzuTkfprOY537owOXz+OuNkuyCrOx77/j2o=";

  meta = with lib; {
    description = "A minimal Djot CLI";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

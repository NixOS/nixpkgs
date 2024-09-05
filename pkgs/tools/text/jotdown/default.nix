{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-lJnHdywxKf3CWgSB91MqQreyUhKArpT2lqQqSIpgnUY=";
  };

  cargoHash = "sha256-ESwo1J5OCJbmlZoTOPaeNIqRCTMAJtgkhrR0bcRqQwk=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

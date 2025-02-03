{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ain";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "jonaslu";
    repo = "ain";
    rev = "v${version}";
    hash = "sha256-JEavBPnF3WW6oCZ1OC8g1dZev4qC7bi74/q2nvXK3mo=";
  };

  vendorHash = "sha256-+72Y8SKvx7KBK5AIBWKlDqQYpHnZc9CNxCdo4yakPb0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.gitSha=${src.rev}"
  ];

  meta = with lib; {
    description = "HTTP API client for the terminal";
    homepage = "https://github.com/jonaslu/ain";
    changelog = "https://github.com/jonaslu/ain/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ain";
  };
}

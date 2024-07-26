{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ain";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jonaslu";
    repo = "ain";
    rev = "v${version}";
    hash = "sha256-LjGiRLTQxJ83fFBYH7RzQjDG8ZzHT/y1I7nXTb4peAo=";
  };

  vendorHash = "sha256-eyB+0D0+4hHG4yKDj/m9QB+8YTyv+por8fTyu/WcZyg=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.gitSha=${src.rev}"
  ];

  meta = with lib; {
    description = "A HTTP API client for the terminal";
    homepage = "https://github.com/jonaslu/ain";
    changelog = "https://github.com/jonaslu/ain/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ain";
  };
}

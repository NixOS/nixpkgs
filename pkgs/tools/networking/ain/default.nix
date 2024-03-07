{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ain";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jonaslu";
    repo = "ain";
    rev = "v${version}";
    hash = "sha256-QBtnVtTGONbYToGhZ0L4CZ3o2hViEN1l94ZKJHVMd1w=";
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
  };
}

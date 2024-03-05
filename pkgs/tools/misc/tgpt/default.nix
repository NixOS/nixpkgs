{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tgpt";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    rev = "refs/tags/v${version}";
    hash = "sha256-+5hNcemVVuCX1FCL6U9SoJ/Jsef9exQXQFCdPj8qhCk=";
  };

  vendorHash = "sha256-HXpSoihk0s218DVCHe9VCGLBggWY8I25sw2qSaiUz4I=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "tgpt";
  };
}

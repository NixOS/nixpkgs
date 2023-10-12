{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tgpt";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    rev = "refs/tags/v${version}";
    hash = "sha256-4zm2dsYhN5itGto39p2Aq+9vF4iqqjCGwMWACuKSMs0=";
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
  };
}

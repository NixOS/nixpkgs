{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tgpt";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    rev = "refs/tags/v${version}";
    hash = "sha256-68+cP/s4YR7y6ok2mctcMTqDoyErIs8Bf6Ce/x1P8pU=";
  };

  vendorHash = "sha256-2I5JJWxM6aZx0eZu7taUTL11Y/5HIrXYC5aezrTbbsM=";

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

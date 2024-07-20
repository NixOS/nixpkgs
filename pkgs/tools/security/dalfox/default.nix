{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    rev = "refs/tags/v${version}";
    hash = "sha256-sKW6UYSPgXkZbLiOeYru/XpG/Cpvvhwos6Z5J/WxjXo=";
  };

  vendorHash = "sha256-0eNaH82iCmxaie+nA9qxEWb8Uq6LaEQoU9wRFJ+GFv0=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}

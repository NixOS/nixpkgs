{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gowitness";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    rev = "refs/tags/${version}";
    hash = "sha256-oEEq4f5G0kOpaj4KORbVhZqW4RPkBXC33PXYUHhoMxo=";
  };

  vendorHash = "sha256-2hG+93LzJ+kUVCOXFGk83Asvn7zLWq2BSqrq+eOJhQ0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gowitness";
  };
}

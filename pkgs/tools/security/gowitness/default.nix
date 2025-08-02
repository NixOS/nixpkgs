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
    tag = version;
    hash = "sha256-oEEq4f5G0kOpaj4KORbVhZqW4RPkBXC33PXYUHhoMxo=";
  };

  vendorHash = "sha256-2hG+93LzJ+kUVCOXFGk83Asvn7zLWq2BSqrq+eOJhQ0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gowitness";
  };
}

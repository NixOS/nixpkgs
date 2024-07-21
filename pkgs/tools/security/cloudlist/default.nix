{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    rev = "refs/tags/v${version}";
    hash = "sha256-UyZ9KSjFu/NKiz4AZoKwHiWzh+KOARDmveCWcFbOS7A=";
  };

  vendorHash = "sha256-tMrTAbfD+ip/UxrGTaMswgqo94rJZ0lqqxPgYFhZoTY=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    mainProgram = "cloudlist";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

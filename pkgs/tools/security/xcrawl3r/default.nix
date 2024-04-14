{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "xcrawl3r";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xcrawl3r";
    rev = "refs/tags/${version}";
    hash = "sha256-K7UuWsteI8mEAGOF/g/EbT/Ch6sbmKhiiYB3npdDmFk=";
  };

  vendorHash = "sha256-/yBSrZdlVMZgcKcONBSq7C5IFC30TJL0z6FZRXm+HUs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A CLI utility to recursively crawl webpages";
    homepage = "https://github.com/hueristiq/xcrawl3r";
    changelog = "https://github.com/hueristiq/xcrawl3r/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "xcrawl3r";
  };
}

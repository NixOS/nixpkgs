{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "act";
  version = "0.2.53";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-p2ujmHWIBUcH5UpHHO72ddqSb1C0gWAyKUIT9E6Oyxk=";
  };

  vendorHash = "sha256-W50NodoaKY7s4x7Goyvydxd5Q2lz9m9pFwgcQ9wRGVM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}

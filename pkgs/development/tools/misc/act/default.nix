{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.35";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-igmxiPVq9aWntIkBSl7crrbXM9N9Iv4KULsj5Q2ZL2I=";
  };

  vendorHash = "sha256-FKpNMZrME3HqqVlp09O3Ppb/MjEzYFuawA+WlKFUfME=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
  };
}

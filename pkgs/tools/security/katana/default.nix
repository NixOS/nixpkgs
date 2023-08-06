{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MhvagLlJ3WuZ3eEA0KI0sJ1ioFyqCcC9lejvewIFg5M=";
  };

  vendorHash = "sha256-1XT8VOBztC/V5Yguzq91ZoOWlkdT6fJrvcxp7KvtNqw=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/katana" ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}

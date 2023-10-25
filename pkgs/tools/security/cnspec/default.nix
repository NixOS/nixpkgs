{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "9.2.3";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-gCKmaioBko4UsfhPBcpVxHC7knhZGZU54HZFu/rHIbw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-YN1y+K/9EdZ7RlZRVWK/HEppZv/dX6XrkaqIlZVoC8c=";

  subPackages = [
    "apps/cnspec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${version}"
  ];

  meta = with lib; {
    description = "An open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}

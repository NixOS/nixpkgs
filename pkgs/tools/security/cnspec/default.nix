{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-CzTHEOQ6QTL5M6lS8BgRhf3OXBC/Pa+HabsRrlxQGcU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-7Ro2qRU+ULLLrVT0VpJkwBOQ6EQSgMLiJRRK9IMuXZs=";

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
    license = licenses.bsl11;
    maintainers = with maintainers; [ fab mariuskimmina ];
  };
}

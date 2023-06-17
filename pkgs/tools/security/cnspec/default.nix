{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "8.12.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-ixKBfsb3e1FvvXj0iN2odD2T5x2wtYbdonQ08fbtnY8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-COwAmcd6lcHF2YixOJG/X5PT7kDDdrpN9NdI66kRZQo=";

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

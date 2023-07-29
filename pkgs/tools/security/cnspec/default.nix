{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "8.20.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-VPXxeI4dO6bHUagS38l7358sXW3ot/v/j9MUrD/akNg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-LH9ts/hD16rF9VBJIfwTAQXq9MMAiBKBR3ulKGNrlow=";

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

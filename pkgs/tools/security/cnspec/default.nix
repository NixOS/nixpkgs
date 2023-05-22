{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "8.10.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-xgDHpLnbTAC0OL7Z5JQsOWlarIHqvr7xrDBg6hlWRRw=";
  };

  vendorHash = "sha256-cjM8pj3squAu2KJbeGz5cd3LRGxKX9BGxtF+lUZaFyU=";

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

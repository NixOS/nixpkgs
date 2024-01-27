{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "10.0.3";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-UiEvy0NrdxEubaupGcpVQjqNJ1fKHrj/YA8wqvW0qoY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-gUyQ/bnBVYYlp3a8iifafi5cvvrld6Lq80aRVRg11pY=";

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

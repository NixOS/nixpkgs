{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "10.6.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-wQ11ZHyUh1bSrvWQLTSyOc+EtFp4QS9zcjNz1S+UP7Y=";
  };

  proxyVendor = true;

  vendorHash = "sha256-Z7zPvm3CjHnmGdTvO8ETwgRijcRyGReZ6ba7llOkyME=";

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

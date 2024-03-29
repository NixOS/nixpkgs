{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "10.9.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-9NHzSgcUWRVhq4hqkq8xJ0FgTk9BBz2Zc0yuj72WL+c=";
  };

  proxyVendor = true;

  vendorHash = "sha256-bhpVAvoIriqA7QnYysqUfuAYbR9PoaPHgWCHlJLdgYY=";

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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
  version = "11.11.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-3cjtWdBovnRHFUS9TAPkGbg+XocgkkgJFfkljkyjqUg=";
  };

  proxyVendor = true;

  vendorHash = "sha256-9N1v2i2Cxs7t1d2eI9NQOOqlmc9evV15HH12HZ0gr4U=";

  subPackages = [ "apps/cnspec" ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${version}"
  ];

  meta = with lib; {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      fab
      mariuskimmina
    ];
  };
}

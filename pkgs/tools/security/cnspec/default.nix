{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
  version = "11.28.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-vtefht623aXx6tUXb+MyKjGTyF4YQYQ/Huy8kEkjrVc=";
  };

  proxyVendor = true;

  vendorHash = "sha256-D8AZ1qPon4Ujiw96N79AAA14P0LFDL2W3kmpR4mhOa0=";

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

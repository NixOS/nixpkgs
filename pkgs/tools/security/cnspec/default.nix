{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
  version = "11.42.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${version}";
    hash = "sha256-Occ64wXqYzUw6RZ4fVb85ZotaLRw6R9EcF36BMLJ4ww=";
  };

  proxyVendor = true;

  vendorHash = "sha256-rdNFH2DbZqilA9Qk+8MJeMBziRDoNQRQ7qbhdc1FUbU=";

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

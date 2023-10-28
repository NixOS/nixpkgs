{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cnspec";
  version = "9.4.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-rAvSC+MqgS47n/DFbGoeyvN1GyidvQ37TS+buSYwxME=";
  };

  proxyVendor = true;
  vendorHash = "sha256-xghScwfR82Q9lhx2cNc1JZShppCKQR+tZynk+ee/81c=";

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

{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "atlas";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4IDVsy4CseIiORaC8O72mcHp4w1YHUZfe0xoaxHRQTs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-7+AVDNzydyFO+RmQfybpG6RSU+4qrf/1IEYOSWRBl7Y=";

  ldflags = [
    "-s"
    "-w"
    "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${version}"
  ];

  # subPackages = [ "cmd/atlas"] does not work
  modRoot = "cmd/atlas";

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "An open source tool that helps developers manage their database schemas by applying modern DevOps principles";
    homepage = "https://atlasgo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "litefs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gh1GcIsRNfAwQ2HJq82IlyUHPyaDpA3CpBe4glBbU/I=";
  };

  vendorSha256 = "sha256-dXCyBY4k9Gxsy/7UwkWFTxihZnFkZGrZKgw9pHD8jco=";

  subPackages = [ "cmd/litefs" ];

  # following https://github.com/superfly/litefs/blob/main/Dockerfile
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-extldflags=-static"
  ];

  tags = [
    "osusergo"
    "netgo"
    "sqlite_omit_load_extension"
  ];

  doCheck = false; # fails

  meta = with lib; {
    description = "FUSE-based file system for replicating SQLite databases across a cluster of machines";
    homepage = "https://github.com/superfly/litefs";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

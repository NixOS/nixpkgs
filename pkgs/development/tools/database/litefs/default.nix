{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "litefs";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gTXIQVnNyVn2UqigozvEPaPm3XoqHd6E0RZnZS4bP3g=";
  };

  vendorHash = "sha256-4e1tAAXM2EYuqe1AbN1wng/bq1BP7MSOV6woeKjc3x4=";

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

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "litefs";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oF69bmWI4I/ok89Rgve4eedMR9MCcaxmQ4bGff831dI=";
  };

  vendorHash = "sha256-6Dg1fU4y0eUeiX9uUwJ2IUxBr81vWR6eUuCV+iPBNBk=";

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

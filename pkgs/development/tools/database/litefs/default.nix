{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "litefs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CmWtQzoY/xY/LZL2swhYtDzPvpVOvKlhUH3plDEHrGI=";
  };

  vendorHash = "sha256-1I18ITgFPpUv0mPrt1biJmQV9qd9HB23zJmnDp5WzkA=";

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

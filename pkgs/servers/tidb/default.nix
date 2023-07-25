{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tidb";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7iz82H3H22GCLvy8VD+t1BkEEoNQ0+6ZLBOUwWTlNfI=";
  };

  vendorHash = "sha256-9vgxdX8CPUbyJZNSkwTZK02ORIXACjad/yPef8zB7FU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pingcap/tidb/dumpling/cli.ReleaseVersion=${version}"
    "-X github.com/pingcap/tidb/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "tidb-server" ];

  meta = with lib; {
    description = "An open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = licenses.asl20;
    maintainers = [];
  };
}

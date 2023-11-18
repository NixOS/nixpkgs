{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tidb";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zpAduymFC17iL9eEssFoHxK+J4EP1QyamchfLetFN/k=";
  };

  vendorHash = "sha256-GbAZK2TQKc3bziZm202Q2QLLK0TDJ/AplSGKBSLSoqQ=";

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

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tidb";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U3RGQADiS3mNq+4U+Qn+LMYbX8vxkTmofnRc+yrAcIA=";
  };

  vendorSha256 = "sha256-ljPFNjnmPaUx1PHtjlJh9ubKBDS3PgvbqTce9pi3GSc=";

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
    maintainers = with maintainers; [ candyc1oud ];
  };
}

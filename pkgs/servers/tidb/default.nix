{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tidb";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dlLT1vwRZ6vbfCRcMxevJQ99T2Aq4qaAVwitmcd9yJ4=";
  };

  vendorHash = "sha256-NZv4DrPygSNCcK0A7VTGz0wIuHSR+Tf5Dhf5JuqiQ5A=";

  ldflags = [
    "-X github.com/pingcap/tidb/pkg/parser/mysql.TiDBReleaseVersion=${version}"
    "-X github.com/pingcap/tidb/pkg/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "cmd/tidb-server" ];

  meta = with lib; {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ Makuru ];
    mainProgram = "tidb-server";
  };
}

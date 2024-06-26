{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tidb";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i8soETbTWmFZQqKYcRoLXVIgFCQxHDvXZbJNjDmS8Jo=";
  };

  vendorHash = "sha256-RNYL5tb6d8NhNiOm3x8sgo1SEc8+uMdWgYor/VL3C6s=";

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

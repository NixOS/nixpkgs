{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tidb";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OsyQ7YZjErjfWg/1wf21AxBu2wrotey8hJSzoQQ0OSc=";
  };

  vendorHash = "sha256-jtuf3/CClz37TTQ2zs49yryccoaraAG4UrIOIlBYFqQ=";

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
    mainProgram = "tidb-server";
  };
}

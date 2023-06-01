{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tidb";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-giYAD6BJqK1Z9Rkpy3Xhf4Y4+lmZW6y1CJur0OqZHTU=";
  };

  vendorHash = "sha256-IyVfML4XwogW/SMoZoZcQA32DxuHzuBoNePqk3u1vSw=";

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

{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pyroscope";
  version = "1.1.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "pyroscope";
    hash = "sha256-XLqrQ5E4SWouqsqaHM3TXXODVK3Mhgbl3yeCq4oI8us=";
  };

  proxyVendor = true;
  vendorHash = "sha256-b/AeiSD88UL/5ax+Gvu6CSjUbXd62oneyi6PActI9YI=";

  ldflags = let
    prefix = "github.com/grafana/pyroscope/pkg/util/build";
  in [
    "-s" "-w"
    # https://github.com/grafana/pyroscope/blob/v1.1.0/Makefile#L30
    "-X ${prefix}.Version=${version}"
    "-X ${prefix}.Branch=v${version}"
    "-X ${prefix}.Revision=v${version}"
    "-X ${prefix}.BuildUser=nix"
    "-X ${prefix}.BuildDate=1980-01-01T00:00:00Z"
  ];

  subPackages = [
    "cmd/pyroscope"
    "cmd/profilecli"
  ];

  meta = with lib; {
    description = "Grafana Pyroscope is an open source database that provides fast, scalable, highly available, and efficient storage and querying of profiling data.";
    license = licenses.agpl3;
    homepage = "https://grafana.com/oss/pyroscope";
    changelog = "https://github.com/grafana/pyroscope/releases/tag/v${version}";
    maintainers = with maintainers; [ cathalmullan ];
    mainProgram = "pyroscope";
  };
}

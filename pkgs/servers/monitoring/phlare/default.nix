{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phlare";
  version = "0.3.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "phlare";
    sha256 = "sha256-z1PT5chkpHQJPziY7bGf6W1X5uezL6E2GUV6w/NlyFk=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-KJbh+M9jYxUW9akVBHZoB/mtOHWpMPtlwIgC9fu+NYY=";

  ldflags = let
    prefix = "github.com/grafana/phlare/pkg/util/build";
  in [
    "-s" "-w"
    # https://github.com/grafana/phlare/blob/v0.3.0/Makefile#L32
    "-X ${prefix}.Version=${version}"
    "-X ${prefix}.Branch=v${version}"
    "-X ${prefix}.Revision=v${version}"
    "-X ${prefix}.BuildUser=nix"
    "-X ${prefix}.BuildDate=1980-01-01T00:00:00Z"
  ];

  subPackages = [
    "cmd/phlare"
    "cmd/profilecli"
  ];

  meta = with lib; {
    description = "Grafana Phlare is an open source database that provides fast, scalable, highly available, and efficient storage and querying of profiling data.";
    license = licenses.agpl3;
    homepage = "https://grafana.com/oss/phlare";
    maintainers = with maintainers; [ cathalmullan ];
  };
}

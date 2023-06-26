{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phlare";
  version = "0.6.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "phlare";
    sha256 = "sha256-iaNwOV8XP6H8DDs2HcOIIl8sNM6Xi5VsRxSb80mvvLo=";
  };

  proxyVendor = true;
  vendorHash = "sha256-y8IWS5OQkDYRTt5xOzzbjb1ya6AiFtvAc0YNH99KZBA=";

  ldflags = let
    prefix = "github.com/grafana/phlare/pkg/util/build";
  in [
    "-s" "-w"
    # https://github.com/grafana/phlare/blob/v0.6.1/Makefile#L32
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

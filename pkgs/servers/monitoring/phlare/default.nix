{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phlare";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "phlare";
<<<<<<< HEAD
    sha256 = "sha256-iaNwOV8XP6H8DDs2HcOIIl8sNM6Xi5VsRxSb80mvvLo=";
  };

  proxyVendor = true;
  vendorHash = "sha256-y8IWS5OQkDYRTt5xOzzbjb1ya6AiFtvAc0YNH99KZBA=";
=======
    sha256 = "sha256-q7y3sZMI1Kk7Ar0ER8RoU1Y7xAhFh89y/mzESjLrxcM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Oz1qV+3sB0pOWGEMtp7mgMR9Ljd0rd9oa6NJO2azTJg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = let
    prefix = "github.com/grafana/phlare/pkg/util/build";
  in [
    "-s" "-w"
<<<<<<< HEAD
    # https://github.com/grafana/phlare/blob/v0.6.1/Makefile#L32
=======
    # https://github.com/grafana/phlare/blob/v0.5.1/Makefile#L32
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

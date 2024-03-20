{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "smokeping_prober";
  version = "0.7.3";

  ldflags = let
    setVars = rec {
      Version = version;
      Revision = "722200c4adbd6d1e5d847dfbbd9dec07aa4ca38d";
      Branch = Revision;
      BuildUser = "nix";
    };
    varFlags = lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "-X github.com/prometheus/common/version.${name}=${value}") setVars);
  in [
    "${varFlags}" "-s" "-w"
  ];

  src = fetchFromGitHub {
    owner = "SuperQ";
    repo = "smokeping_prober";
    rev = "v${version}";
    sha256 = "sha256-MP8AJ8XnIp/+9s7qeAGRHv2OtLL5zrjEhuzZ36V/GrY=";
  };
  vendorHash = "sha256-39/0reEt4Rfe7DfysS4BROUgBUg+x95z6DU3IjC6m5U=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smokeping; };

  meta = with lib; {
    description = "Prometheus exporter for sending continual ICMP/UDP pings";
    mainProgram = "smokeping_prober";
    homepage = "https://github.com/SuperQ/smokeping_prober";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
  };
}

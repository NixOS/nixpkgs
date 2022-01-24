{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

let
  baseVersion = "0.4.2";
  commit = "722200c4adbd6d1e5d847dfbbd9dec07aa4ca38d";
in
buildGoModule rec {
  pname = "smokeping_prober";
  version = "${baseVersion}-g${commit}";

  ldflags = let
    setVars = {
      Version = baseVersion;
      Revision = commit;
      Branch = commit;
      BuildUser = "nix";
    };
    varFlags = lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "-X github.com/prometheus/common/version.${name}=${value}") setVars);
  in [
    "${varFlags}" "-s" "-w"
  ];

  src = fetchFromGitHub {
    rev = commit;
    owner = "SuperQ";
    repo = "smokeping_prober";
    sha256 = "1lpcjip6qxhalldgm6i2kgbajfqy3vwfyv9jy0jdpii13lv6mzlz";
  };
  vendorSha256 = "0p2jmlxpvpaqc445j39b4z4i3mnjrm25khv3sq6ylldcgfd31vz8";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smokeping; };

  meta = with lib; {
    description = "Prometheus exporter for sending continual ICMP/UDP pings";
    homepage = "https://github.com/SuperQ/smokeping_prober";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}

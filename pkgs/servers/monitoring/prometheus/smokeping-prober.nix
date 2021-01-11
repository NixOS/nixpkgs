{ lib, stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

let
  inherit (stdenv) lib;
  baseVersion = "0.3.1";
  commit = "9ba85274dcc21bf8132cbe3b3dccfcb4aab57d9f";
in
buildGoModule rec {
  pname = "smokeping_prober";
  version = "${baseVersion}-g${commit}";

  buildFlagsArray = let
    setVars = {
      Version = baseVersion;
      Revision = commit;
      Branch = commit;
      BuildUser = "nix";
    };
    varFlags = lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "-X github.com/prometheus/common/version.${name}=${value}") setVars);
  in [
    "-ldflags=${varFlags} -s -w"
  ];

  src = fetchFromGitHub {
    rev = commit;
    owner = "SuperQ";
    repo = "smokeping_prober";
    sha256 = "sha256:19596di2gzcvlcwiypsncq4zwbyb6d1r6wxsfi59wax3423i7ndg";
  };
  vendorSha256 = "sha256:1b2v3v3kn0m7dvjxbs8q0gw6zingksdqhm5g1frx0mymqk0lg889";

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

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "alertmanager-irc-relay";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alertmanager-irc-relay";
    rev = "v${version}";
    sha256 = "sha256-Rl7o2QPa/IU1snlx/LiJxQok9pnkw9XANnJsu41vNlY=";
  };

  vendorHash = "sha256-KX+TR0n14+95lldF+0KUo5DbqOKpUDaZNuKMBf0KHFQ=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Alertmanager IRC Relay is a bot relaying Prometheus alerts to IRC";
    mainProgram = "alertmanager-irc-relay";
    longDescription = ''
      Alertmanager IRC Relay is a bot relaying Prometheus alerts to IRC.
      Alerts are received from Prometheus using Webhooks and are relayed to an
      IRC channel
    '';
    homepage = "https://github.com/google/alertmanager-irc-relay";
    license = licenses.asl20;
    maintainers = with maintainers; [ ymatsiuk ];
  };
}

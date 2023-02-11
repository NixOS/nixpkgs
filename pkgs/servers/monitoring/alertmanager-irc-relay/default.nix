{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "alertmanager-irc-relay";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alertmanager-irc-relay";
    rev = "v${version}";
    sha256 = "sha256-qE+cKwn/rqxL5/LUSirflmnFCow6IxjCcGvu2bbBmsk=";
  };

  vendorSha256 = "sha256-VLG15IXS/fXFMTCJKEqGW6qZ9aOLPhazidVsOywG+w4=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Alertmanager IRC Relay is a bot relaying Prometheus alerts to IRC";
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

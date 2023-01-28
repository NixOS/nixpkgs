{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "sensu";
  gemdir = ./.;
  exes = [
    "sensu-api"
    "sensu-client"
    "sensu-install"
    "sensu-server"

    # indirect, but might be important
    "check-disk-usage.rb"
    "check-fstab-mounts.rb"
    "check-smart.rb"
    "check-smart-status.rb"
    "check-smart-tests.rb"
    "metrics-disk-capacity.rb"
    "metrics-disk.rb"
    "metrics-disk-usage.rb"

    "check-head-redirect.rb"
    "check-http-cors.rb"
    "check-http-json.rb"
    "check-http.rb"
    "check-https-cert.rb"
    "check-last-modified.rb"
    "metrics-curl.rb"
    "metrics-http-json-deep.rb"
    "metrics-http-json.rb"

    "check-influxdb-query.rb"
    "check-influxdb.rb"
    "metrics-influxdb.rb"
    "mutator-influxdb-line-protocol.rb"

    "check-journal.rb"
    "check-log.rb"
    "handler-logevent.rb"
    "handler-show-event-config.rb"

    "check-systemd.rb"
  ];

  passthru.updateScript = bundlerUpdateScript "sensu";

  meta = with lib; {
    description = "A monitoring framework that aims to be simple, malleable, and scalable";
    homepage    = "https://sensuapp.org/";
    license     = licenses.mit;
    maintainers = with maintainers; [ theuni peterhoeg manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}

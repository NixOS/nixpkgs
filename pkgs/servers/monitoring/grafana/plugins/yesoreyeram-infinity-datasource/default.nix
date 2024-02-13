{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "yesoreyeram-infinity-datasource";
  version = "2.4.0";
  zipHash = {
    x86_64-linux = "sha256-xWJ7fPTq4WvlChe7y6iuwTjHY8mNwHAOkMQdgJCTgcw=";
    aarch64-linux = "sha256-ien1/kfW0KseK27N2RgR3L1REqL+BGg6vQtQdJ4clBg=";
    x86_64-darwin = "sha256-nVwp4GHOpZzaQKzpbp8FctGiynbDjAeTB57Fk1nQZ+s=";
    aarch64-darwin = "sha256-UIm6jc7LSMRixHbYUHydW3clT0yOoXGhpRDE8tStiNA=";
  };
  meta = with lib; {
    description = "Visualize data from JSON, CSV, XML, GraphQL and HTML endpoints in Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}

{ goPackages, lib, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prom2json-${rev}";
  rev = "0.1.0";
  goPackagePath = "github.com/prometheus/prom2json";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "prom2json";
    inherit rev;
    sha256 = "0wwh3mz7z81fwh8n78sshvj46akcgjhxapjgfic5afc4nv926zdl";
  };

  buildInputs = with goPackages; [
    golang_protobuf_extensions
    prometheus.client_golang
    protobuf
  ];

  meta = with lib; {
    description = "A tool to scrape a Prometheus client and dump the result as JSON";
    homepage = https://github.com/prometheus/prom2json;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}

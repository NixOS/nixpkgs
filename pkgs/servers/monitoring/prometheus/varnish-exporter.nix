{ lib, buildGoModule, fetchFromGitHub, makeWrapper, varnish, nixosTests }:

buildGoModule rec {
  pname = "prometheus_varnish_exporter";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = version;
    hash = "sha256-1sUzKLNkLP/eX0wYSestMAJpjAmX1iimjYoFYb6Mgpc=";
  };

  vendorHash = "sha256-P2fR0U2O0Y4Mci9jkAMb05WR+PrpuQ59vbLMG5b9KQI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/prometheus_varnish_exporter \
      --prefix PATH : "${varnish}/bin"
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) varnish; };

  meta = {
    homepage = "https://github.com/jonnenauha/prometheus_varnish_exporter";
    description = "Varnish exporter for Prometheus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
  };
}

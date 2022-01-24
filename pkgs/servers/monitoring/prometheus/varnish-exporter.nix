{ lib, buildGoModule, fetchFromGitHub, makeWrapper, varnish, nixosTests }:

buildGoModule rec {
  pname = "prometheus_varnish_exporter";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = version;
    sha256 = "1cp7c1w237r271m8b1y8pj5jy7j2iadp4vbislxfyp4kga9i4dcc";
  };

  vendorSha256 = "1cslg29l9mmyhpdz14ca9m18iaz4hhznplz8fmi3wa3l8r7ih751";

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
    maintainers = with lib.maintainers; [ MostAwesomeDude willibutz ];
  };
}

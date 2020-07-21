{ lib, buildGoModule, fetchFromGitHub, makeWrapper, varnish, nixosTests }:

buildGoModule rec {
  pname = "prometheus_varnish_exporter";
  version = "unstable-2020-03-26";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = "f0f90fc69723de8b716cda16cb419e8a025130ff";
    sha256 = "1viiiyvhpr7cnf8ykaaq4fzgg9xvn4hnlhv7cagy3jkjlmz60947";
  };

  vendorSha256 = "1h9iz3sbz02hb8827hcssqlfg2ag3ymq38siffw9wzajslzhp9sx";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/prometheus_varnish_exporter \
      --prefix PATH : "${varnish}/bin"
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) varnish; };

  meta = {
    homepage = "https://github.com/jonnenauha/prometheus_varnish_exporter";
    description = "Varnish exporter for Prometheus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MostAwesomeDude willibutz ];
  };
}

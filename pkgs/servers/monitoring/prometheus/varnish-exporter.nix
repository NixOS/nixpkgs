{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, varnish }:

buildGoPackage rec {
  name = "prometheus_varnish_exporter-${version}";
  version = "1.5";

  goPackagePath = "github.com/jonnenauha/prometheus_varnish_exporter";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = version;
    sha256 = "1040x7fk3s056yrn95siilhi8c9cci2mdncc1xfjf5xj87421qx8";
  };

  goDeps = ./varnish-exporter_deps.nix;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/prometheus_varnish_exporter \
      --prefix PATH : "${varnish}/bin"
  '';

  doCheck = true;

  meta = {
    homepage = "https://github.com/jonnenauha/prometheus_varnish_exporter";
    description = "Varnish exporter for Prometheus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MostAwesomeDude willibutz ];
  };
}

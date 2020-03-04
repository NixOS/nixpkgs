{ lib, buildGoModule, fetchFromGitHub, makeWrapper, varnish }:

buildGoModule rec {
  pname = "prometheus_varnish_exporter";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = version;
    sha256 = "0rpabw6a6paavv62f0gzhax9brzcgkly27rhkf0ihw8736gkw8ar";
  };

  modSha256 = "0w1zg9jc2466srx9pdckw7rzn7ma4pbd0617b1h98v364wjzgj72";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/prometheus_varnish_exporter \
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

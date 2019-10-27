{ lib, buildGoModule, fetchFromGitHub, makeWrapper, varnish }:

buildGoModule rec {
  pname = "prometheus_varnish_exporter";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = version;
    sha256 = "1lvs44936n3s9z6c5169jbvx390n5g0qk4pcrmnkndg796ixjshd";
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

{ lib, buildGoModule, fetchFromGitHub, makeWrapper, varnish, nixosTests }:

buildGoModule rec {
  pname = "prometheus_varnish_exporter";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jonnenauha";
    repo = "prometheus_varnish_exporter";
    rev = version;
    sha256 = "15w2ijz621caink2imlp1666j0ih5pmlj62cbzggyb34ncl37ifn";
  };

  vendorSha256 = "00i9znb1pk5jpmyhxfg9zbw935fk3c1r0qrgf868xlcf9p8x2rrz";

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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
=======
    maintainers = with lib.maintainers; [ MostAwesomeDude willibutz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

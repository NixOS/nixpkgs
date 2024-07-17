{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f60zAE94jdJaGjn+SoO1qs3SgWRpK9pdbirRrsKKBJQ=";
  };

  vendorHash = "sha256-lioFmaFzqaxN1wnYJaoHA54to1xGZjaLGaqAFIfTaTs=";

  subPackages = [ "cmd/grr" ];

  meta = with lib; {
    description = "Utility for managing Jsonnet dashboards against the Grafana API";
    homepage = "https://grafana.github.io/grizzly/";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = platforms.unix;
    mainProgram = "grr";
  };
}

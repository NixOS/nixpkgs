{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UOUBck1GrG3ijUpE3jPaFcC/KtlObaR38u3St8NToTk=";
  };

  vendorHash = "sha256-lioFmaFzqaxN1wnYJaoHA54to1xGZjaLGaqAFIfTaTs=";

  subPackages = [ "cmd/grr" ];

  meta = with lib; {
    description = "A utility for managing Jsonnet dashboards against the Grafana API";
    homepage = "https://grafana.github.io/grizzly/";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = platforms.unix;
    mainProgram = "grr";
  };
}

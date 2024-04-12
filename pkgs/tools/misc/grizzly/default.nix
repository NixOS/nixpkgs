{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IM7NrykF2Fiudijo5q0I/FewvS/rs3lzSpvzc6dl5Ds=";
  };

  vendorHash = "sha256-GrzMfOwNEjVQd1uCijcsfdIDO6UPzuHEDnJExupB9Jg=";

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

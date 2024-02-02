{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d/DUazWBT96+dnwVXo667RHALUM2FHxXoI54fFU2HZw=";
  };

  vendorHash = "sha256-8myfB2LKDPUCFV9GBSXrBo9E+WrCOCm0ZHKTQ1dEb9U=";

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

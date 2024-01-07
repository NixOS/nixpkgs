{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Yc15mD21Ohga7Pw+iowegkI2DWbKIZOZQ2vkKOdsKUk=";
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

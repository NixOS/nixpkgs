{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6z/6QZlCm4mRMKAVzLnOokv8ib7Y/7a17ojjMfeoJ4w=";
  };

  vendorHash = "sha256-DDYhdRPcD5hfSW9nRmCWpsrVmIEU1sBoVvFz5Begx8w=";

  subPackages = [ "cmd/grr" ];

  meta = with lib; {
    description = "A utility for managing Jsonnet dashboards against the Grafana API";
    homepage = "https://grafana.github.io/grizzly/";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = platforms.unix;
  };
}

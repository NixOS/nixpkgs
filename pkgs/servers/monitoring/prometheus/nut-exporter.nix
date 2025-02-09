{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-sX0yNuUg/x8BtMLbbq1gz+4//Cce+n5Qi/zspC7/scI=";
  };

  vendorHash = "sha256-DGCNYklINPPzC7kCdEUS7TqVvg2SnKFqe0qHs5RSmzY=";

  meta = with lib; {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ jhh ];
  };
}

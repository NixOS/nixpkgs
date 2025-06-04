{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-6qexTBCLitL+dgT1Ff+414AUQqgn9s+CP5J5MkByb7s=";
  };

  vendorHash = "sha256-cMZ4GSal03LIZi7ESr/sQx8zLHNepOTZGEEsdvsNhec=";

  meta = with lib; {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ jhh ];
  };
}

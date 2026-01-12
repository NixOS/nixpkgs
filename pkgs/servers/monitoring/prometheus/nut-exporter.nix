{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-tgYxkVen2aegX+py9goQIQtw1eNZJ7K8CqgaKOsDgxA=";
  };

  vendorHash = "sha256-cMZ4GSal03LIZi7ESr/sQx8zLHNepOTZGEEsdvsNhec=";

  meta = {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jhh ];
  };
}

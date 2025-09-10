{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-TqBwvOuhcnQbJBfzJ8nc3EYVo8fyCPwne+vEYZeX9/I=";
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

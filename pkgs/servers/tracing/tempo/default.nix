{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "1.0.1";
  pname = "tempo";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tempo";
    sha256 = "sha256-4QrCoz4taNXV13g+Pi0j7pTWy0hLY/qAdTOIMMuDWIA=";
  };

  vendorSha256 = null;

  # tests use docker
  doCheck = false;

  meta = with lib; {
    description = "A high volume, minimal dependency trace storage";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}

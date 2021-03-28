{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "0.5.0";
  pname = "tempo";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tempo";
    sha256 = "sha256-Har0JJqr6mkliKh25n+F4tork+bzfI/bv19H/rIRb9g=";
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

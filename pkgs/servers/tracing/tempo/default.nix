{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "0.4.0";
  pname = "tempo";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tempo";
    sha256 = "16hrvhnlciaf06l34p3bb3nvmxr8zwbh7zql13zja1hs0kvwxv5c";
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

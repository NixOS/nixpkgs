{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "1.4.1";
  pname = "tempo";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tempo";
    sha256 = "sha256-kxR+xwhthsK3gThs0jPJfWlsRG35kCuWvKH3Wr7ENTs=";
    fetchSubmodules = true;
  };

  vendorSha256 = null;

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    # FIXME: build is broken upstream, enable for next release
    # "cmd/tempo-serverless"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

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

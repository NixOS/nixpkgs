{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "1.1.0";
  pname = "tempo";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tempo";
    sha256 = "sha256-qKsgcc62HTwl7Usmp8zk4vKDo4XEJnwL+A3hoLhgBkk=";
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

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "0.3.0";
  pname = "tempo";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "tempo";
    sha256 = "0inqljiavqyq8dk2w0w0l2bds5390mrf8j190yb7lqwx9ra0cjp9";
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

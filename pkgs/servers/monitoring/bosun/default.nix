{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "bosun";
  version = "0.8.0-preview";

  src = fetchFromGitHub {
    owner = "bosun-monitor";
    repo = "bosun";
    rev = version;
    sha256 = "172mm006jarc2zm2yq7970k2a9akmyzvsrr8aqym4wk5v9x8kk0r";
  };

  subPackages = [ "cmd/bosun" "cmd/scollector" ];
  goPackagePath = "bosun.org";

  meta = with lib; {
    description = "Time Series Alerting Framework";
    license = licenses.mit;
    homepage = "https://bosun.org";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-dgSrjSAO0MwVML07gIqI9hIgRu+Pgv2jZOItSFd0DVU=";
  };

  vendorHash = "sha256-IGxETjZ2RCvhcA7XUQYbr2jf+9P/WReuAOLIpE3kyes=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}

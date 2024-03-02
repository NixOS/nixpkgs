{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-dCRuF1AYTcF2fKD7w7Gze2lE1hZYzpRz9u5p9uxqML0=";
  };

  vendorHash = "sha256-j3FpQ48LjIVteN80zvz88FF3z+pYD2aHJW4VxT0z0vI=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}

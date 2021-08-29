{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gauge";
  version = "1.1.6";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "02yrk4d5mm4j2grlhqkf4grxawx91kd2vhdn7k5wd2dl6wsnlgcl";
  };

  meta = with lib; {
   description = "Light weight cross-platform test automation";
   homepage    = "https://gauge.org";
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

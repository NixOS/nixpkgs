{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gauge-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "1dnlqnpzqsikpxy2mndrmxpcsj4r1zcjmv8px1idzblp117vsnw1";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = https://gauge.org;
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

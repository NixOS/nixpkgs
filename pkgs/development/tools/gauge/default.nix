{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gauge-${version}";
  version = "1.0.3";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "0dcsgszg6ilf3sxan3ahf9cfpw66z3mh2svg2srxv8ici3ak8a2x";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = https://gauge.org;
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

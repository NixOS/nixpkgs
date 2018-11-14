{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gauge-${version}";
  version = "1.0.2";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "0cnhkxfw78i4lgkbrk87hgrjh98f0z6a97g77c9av20z4962hmfy";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = https://gauge.org;
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

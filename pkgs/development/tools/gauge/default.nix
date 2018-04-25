{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gauge-${version}";
  version = "0.9.7";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "09afsi97yxlqwmrxvihravqvz17m7y402gbw4hvdk0iixa6jpq6a";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = http://gauge.org;
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gauge-${version}";
  version = "1.0.4";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "1b52kpv5561pyjvqi8xmidarqp6lcyyy4sjsl4qjx4cr7hmk8kc7";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = https://gauge.org;
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

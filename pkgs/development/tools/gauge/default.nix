{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gauge-${version}";
  version = "0.9.6";

  goPackagePath = "github.com/getgauge/gauge";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "0p2bnrzgx616jbyr9h4h9azaq7ry63z4qkwgy0ivwrpmhfqfqwmh";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = http://gauge.org;
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

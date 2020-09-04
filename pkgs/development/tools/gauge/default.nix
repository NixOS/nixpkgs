{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gauge";
  version = "1.1.3";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "11qllg1alv9khkgjarpzlsqg5ygisjprg79n2jqhv1w6izx88cqc";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = "https://gauge.org";
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

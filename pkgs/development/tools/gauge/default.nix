{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gauge";
  version = "1.1.4";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "07kq6j5scbcicgb8dqkf129q5ppvnlvkfp165ql30jrkfd6ybf6y";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = "https://gauge.org";
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

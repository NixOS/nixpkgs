{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gauge";
  version = "1.1.1";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "01x4838jljhhhcwfh6zbhy3g7l7nqvypv3g0ch9n2amsf2s16s3l";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = "https://gauge.org";
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

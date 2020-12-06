{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gauge";
  version = "1.1.5";

  goPackagePath = "github.com/getgauge/gauge";
  excludedPackages = ''\(build\|man\)'';

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "0jijw9x1ccqbb9kkzx1bj3wsq6v1415hvlbiihswqbb559bcmira";
  };

  meta = with stdenv.lib; {
   description = "Light weight cross-platform test automation";
   homepage    = "https://gauge.org";
   license     = licenses.gpl3;
   maintainers = [ maintainers.vdemeester ];
   platforms   = platforms.unix;
  };
}

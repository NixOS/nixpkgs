{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gomodifytags-unstable";
  version = "2018-09-14";
  rev = "141225bf62b6e5c9c0c9554a2e993e8c30aebb1d";

  goPackagePath = "github.com/fatih/gomodifytags";

  src = fetchFromGitHub {
    inherit rev;
    owner = "fatih";
    repo = "gomodifytags";
    sha256 = "16qbp594l90qpvf388wlv0kf6wvqj1vz2mqq0g3qcz6dkrc4cjqa";
  };

  meta = {
    description = "Go tool to modify struct field tags.";
    homepage = https://github.com/fatih/gomodifytags;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.bsd3;
  };
}

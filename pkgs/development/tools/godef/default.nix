{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "godef-${version}";
  version = "20170920-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "b692db1de5229d4248e23c41736b431eb665615d";

  goPackagePath = "github.com/rogpeppe/godef";
  excludedPackages = "go/printer/testdata";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/rogpeppe/godef";
    sha256 = "0xqp9smfyznm8v2iy4wyy3kd24mga12fx0y0896qimac4hj2al15";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    homepage = https://github.com/rogpeppe/godef/;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.bsd3;
  };
}

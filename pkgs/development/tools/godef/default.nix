{ stdenv, lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "godef-${version}";
  version = "20160620-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "ee532b944160bb27b6f23e4f5ef38b8fdaa2a6bd";

  goPackagePath = "github.com/rogpeppe/godef";
  excludedPackages = "go/printer/testdata";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/rogpeppe/godef";
    sha256 = "1r8c4ijjnwvb9pci4wasmq88yj0ginwly2542kw4hyg2c87j613l";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    homepage = https://github.com/rogpeppe/godef/;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.bsd3;
  };
}

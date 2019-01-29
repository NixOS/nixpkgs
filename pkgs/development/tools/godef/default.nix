{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "godef-${version}";
  version = "1.0.0";
  rev = "7b4626be9fa8081987905fd4719d2f6628f9d8b5";

  goPackagePath = "github.com/rogpeppe/godef";
  excludedPackages = "go/printer/testdata";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/rogpeppe/godef";
    sha256 = "0zhw4ba19hy0kv74c58ax759h8721khmwj04fak2y5800ymsgndg";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    homepage = https://github.com/rogpeppe/godef/;
    maintainers = with stdenv.lib.maintainers; [ vdemeester rvolosatovs ];
    license = stdenv.lib.licenses.bsd3;
  };
}

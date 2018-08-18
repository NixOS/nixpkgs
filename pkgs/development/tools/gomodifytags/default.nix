{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "gomodifytags-${version}";
  version = "unstable-2017-12-14";
  rev = "20644152db4fe0ac406d81f3848e8a15f0cdeefa";

  goPackagePath = "github.com/fatih/gomodifytags";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/fatih/gomodifytags";
    sha256 = "0k0ly3mmm9zcaxwlzdbvdxr2gn7kvcqzk1bb7blgq7fkkzpp7i1q";
  };

  meta = {
    description = "Go tool to modify struct field tags.";
    homepage = https://github.com/fatih/gomodifytags;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.bsd3;
  };
}

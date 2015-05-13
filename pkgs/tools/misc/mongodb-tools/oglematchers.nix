{ stdenv, goPackages, fetchgit }:

with goPackages;

buildGoPackage rec {
  rev = "3ecefc49db07722beca986d9bb71ddd026b133f0";
  name = "oglematchers-${stdenv.lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/jacobsa/oglematchers";
  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}.git";
    sha256 = "0g97imiysd3zxz60d1s83qfyayxaa9ss9y4hpqfkvv52y12zkd27";
  };
  #goTestInputs = [ ogletest ];
  doCheck = false; # infinite recursion
}

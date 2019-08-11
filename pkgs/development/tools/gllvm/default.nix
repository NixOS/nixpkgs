{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gllvm-${version}";
  version = "1.2.3";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "12kdgsma62nzksvw266qm3ivkbz62ma93dd25wy0p19789v4fi7s";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/gllvm;
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

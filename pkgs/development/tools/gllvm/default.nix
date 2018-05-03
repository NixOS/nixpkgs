{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gllvm-${version}";
  version = "1.2.0";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "0779828kzw9ihdnw5r3h2fzzd8ml8cskyf5hmaqqksinjb7bm3is";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/gllvm;
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

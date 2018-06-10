{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gllvm-${version}";
  version = "1.2.2";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "1k6081frnc6i6h3fa8d796cirhbf5kkshw7qyarz5wi3fcgijn4s";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/gllvm;
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

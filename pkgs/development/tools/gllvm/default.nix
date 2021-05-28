{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gllvm";
  version = "1.2.7";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "13cmmgbcdfgyxnxqfrn4m6vf0bhpday8lmrr3sm6rk48g77cq203";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/SRI-CSL/gllvm";
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

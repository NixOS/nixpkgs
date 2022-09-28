{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gllvm";
  version = "1.3.1";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "sha256-CoreqnMRuPuv+Ci1uyF3HJCJFwK2jwB79okynv6AHTA=";
  };

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/gllvm";
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

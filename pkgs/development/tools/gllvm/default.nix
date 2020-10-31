{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gllvm";
  version = "1.2.8";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "090ghg7ivf6snkabba00pn8a9x5wj8dgpdq7qjhmw1lpijd0mq0y";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/SRI-CSL/gllvm";
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

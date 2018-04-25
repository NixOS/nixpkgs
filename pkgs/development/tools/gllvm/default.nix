{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gllvm-${version}";
  version = "2018-02-09";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "ef83222afd22452dd1277329df227a326db9f84f";
    sha256 = "068mc8q7jmpjzh6pr0ygvv39mh4k7vz0dmiacxf3pdsigy3d1y1a";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/gllvm;
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

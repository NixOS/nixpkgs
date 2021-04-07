{ lib, stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "hevea-2.35";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "sha256-8Ym62l0+WzWFXf39tbJwyZT8eiNmsBJQ12E1mtZsnss=";
  };

  buildInputs = with ocamlPackages; [ ocaml ocamlbuild ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = "http://pauillac.inria.fr/~maranget/hevea/";
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}

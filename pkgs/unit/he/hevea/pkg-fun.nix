{ lib, stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "hevea";
  version = "2.36";

  src = fetchurl {
    url = "https://pauillac.inria.fr/~maranget/hevea/distri/hevea-${version}.tar.gz";
    sha256 = "sha256-XWdZ13AqKVx2oSwbKhoWdUqw7B/+1z/J0LE4tB5yBkg=";
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

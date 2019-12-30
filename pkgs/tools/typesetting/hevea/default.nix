{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "hevea-2.32";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "1s4yqphfcr1pf5mcj5c84mvmd107k525iiym5jdwsxz0ka0ccmfy";
  };

  buildInputs = with ocamlPackages; [ ocaml ocamlbuild ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = http://pauillac.inria.fr/~maranget/hevea/;
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}

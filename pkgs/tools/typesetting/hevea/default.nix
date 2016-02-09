{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "hevea-2.28";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "14fns13wlnpiv9i05841kvi3cq4b9v2sw5x3ff6ziws28q701qnd";
  };

  buildInputs = [ ocaml ];

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = http://pauillac.inria.fr/~maranget/hevea/;
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
  };
}

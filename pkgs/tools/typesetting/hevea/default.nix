{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "hevea-2.33";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "0115bn6n6hhb08rmj0m508wjcsn1mggiagqly6s941pq811wxymb";
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

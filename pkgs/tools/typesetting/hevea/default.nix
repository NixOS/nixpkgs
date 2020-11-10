{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "hevea-2.34";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "1pzyszxw90klpcmhjqrjfc8cw6c0gm4w2blim8ydyxb6rq6qml1s";
  };

  buildInputs = with ocamlPackages; [ ocaml ocamlbuild ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = "http://pauillac.inria.fr/~maranget/hevea/";
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}

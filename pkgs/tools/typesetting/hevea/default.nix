{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "hevea-2.23";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "1f9pj48518ixhjxbviv2zx27v4anp92zgg3x704g1s5cki2w33nv";
  };

  buildInputs = [ ocaml ];

  configurePhase = ''
    export makeFlags="PREFIX=$out";
  '';

  meta = with stdenv.lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = http://pauillac.inria.fr/~maranget/hevea/;
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
  };
}

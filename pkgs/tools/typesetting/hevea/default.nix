{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "hevea-2.25";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "0kn99v92xsfy12r9gfvwgs0xf3s9s6frfg86a8q6damj1dampiz4";
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

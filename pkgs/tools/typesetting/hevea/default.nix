{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "hevea-2.26";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "173v6z2li12pah6315dfpwhqrdljkhsff82gj7sql812zwjkvd2f";
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

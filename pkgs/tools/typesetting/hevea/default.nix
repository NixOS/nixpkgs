{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "hevea-2.29";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~maranget/hevea/distri/${name}.tar.gz";
    sha256 = "1i7qkar6gjpsxqgdm90xxgp15z7gfyja0rn62n23a9aahc0hpgq6";
  };

  buildInputs = [ ocaml ];

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "A quite complete and fast LATEX to HTML translator";
    homepage = http://pauillac.inria.fr/~maranget/hevea/;
    license = licenses.qpl;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}

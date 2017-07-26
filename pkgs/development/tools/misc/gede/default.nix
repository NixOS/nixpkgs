{ stdenv, fetchurl, makeWrapper, python, qt4, ctags, gdb }:

stdenv.mkDerivation rec {
  name = "gede-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${name}.tar.xz";
    sha256 = "0ip86ss35sc330p4aykv5qj74jbdwh38i928w1bxb6g3w0xmfqba";
  };

  nativeBuildInputs = [ makeWrapper python ];

  buildInputs = [ qt4 ];

  postPatch = ''
    sed -i build.py -e 's,qmake-qt4,qmake,'
  '';

  buildPhase = ":";

  installPhase = ''
    python build.py install --prefix="$out"
    wrapProgram $out/bin/gede \
      --prefix PATH : ${stdenv.lib.makeBinPath [ ctags gdb ]}
  '';

  meta = with stdenv.lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = "http://gede.acidron.com";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos ];
  };
}

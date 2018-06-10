{ stdenv, fetchurl, makeWrapper, python, qmake, ctags, gdb }:

stdenv.mkDerivation rec {
  name = "gede-${version}";
  version = "2.6.1";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${name}.tar.xz";
    sha256 = "0jallpchl3c3i90hwic4n7n0ggk5wra0fki4by9ag26ln0k42c4r";
  };

  nativeBuildInputs = [ qmake makeWrapper python ];

  buildInputs = [ ctags ];

  dontUseQmakeConfigure = true;

  buildPhase = ":";

  installPhase = ''
    python build.py install --verbose --prefix="$out"
    wrapProgram $out/bin/gede \
      --prefix PATH : ${stdenv.lib.makeBinPath [ ctags gdb ]}
  '';

  meta = with stdenv.lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = http://gede.acidron.com;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos ];
  };
}

{ stdenv, fetchurl, makeWrapper, python, qmake, ctags, gdb }:

stdenv.mkDerivation rec {
  name = "gede-${version}";
  version = "2.10.9";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${name}.tar.xz";
    sha256 = "0av9v3r6x6anjjm4hzn8wxnvrqc8zp1g7570m5ndg7cgc3sy3bg6";
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}

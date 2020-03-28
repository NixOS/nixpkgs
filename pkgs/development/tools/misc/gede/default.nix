{ mkDerivation, lib, fetchurl, makeWrapper, python, qmake, ctags, gdb }:

mkDerivation rec {
  pname = "gede";
  version = "2.16.2";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${pname}-${version}.tar.xz";
    sha256 = "18a8n9yvhgkbc97p2995j7b5ncfdzy1fy13ahdafqmcpkl4r1hrj";
  };

  nativeBuildInputs = [ qmake makeWrapper python ];

  buildInputs = [ ctags ];

  dontUseQmakeConfigure = true;

  buildPhase = ":";

  installPhase = ''
    python build.py install --verbose --prefix="$out"
    wrapProgram $out/bin/gede \
      --prefix PATH : ${lib.makeBinPath [ ctags gdb ]} 
  '';

  meta = with lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = http://gede.acidron.com;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}

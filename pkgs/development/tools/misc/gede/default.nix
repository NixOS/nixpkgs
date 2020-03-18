{ mkDerivation, lib, fetchurl, makeWrapper, python, qmake, ctags, gdb }:

mkDerivation rec {
  pname = "gede";
  version = "2.16.1";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${pname}-${version}.tar.xz";
    sha256 = "0r8vxsw6q93iip522ghy53wf45rdyzw6npm3ndcfvdg774fkgkln";
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
    homepage = "http://gede.acidron.com";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}

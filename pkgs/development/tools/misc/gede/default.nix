{ mkDerivation, lib, fetchurl, makeWrapper, python3, qmake, ctags, gdb }:

mkDerivation rec {
  pname = "gede";
  version = "2.18.3";

  src = fetchurl {
    url = "http://gede.dexar.se/uploads/source/${pname}-${version}.tar.xz";
    sha256 = "sha256-RUl60iPa4XSlUilpYKaYQbRmLqthKHAvYonnhufjPsE=";
  };

  nativeBuildInputs = [ qmake makeWrapper python3 ];

  buildInputs = [ ctags ];

  strictDeps = true;

  dontUseQmakeConfigure = true;

  dontBuild = true;

  installPhase = ''
    python build.py install --verbose --prefix="$out"
    wrapProgram $out/bin/gede \
      --prefix PATH : ${lib.makeBinPath [ ctags gdb ]}
  '';

  meta = with lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = "http://gede.dexar.se";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}

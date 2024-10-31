{ lib, symlinkJoin, brasero-unwrapped, cdrtools, libdvdcss, makeWrapper }:

let
  binPath = lib.makeBinPath [ cdrtools ];
in symlinkJoin {
  name = "brasero-${brasero-unwrapped.version}";

  paths = [ brasero-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/brasero \
      --prefix PATH ':' ${binPath} \
      --prefix LD_PRELOAD : ${lib.makeLibraryPath [ libdvdcss ]}/libdvdcss.so
  '';

  inherit (brasero-unwrapped) meta;
}

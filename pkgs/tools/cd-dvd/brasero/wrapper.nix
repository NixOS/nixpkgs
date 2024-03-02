{ lib, symlinkJoin, brasero-original, cdrtools, libdvdcss, makeWrapper }:

let
  binPath = lib.makeBinPath [ cdrtools ];
in symlinkJoin {
  name = "brasero-${brasero-original.version}";

  paths = [ brasero-original ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/brasero \
      --prefix PATH ':' ${binPath} \
      --prefix LD_PRELOAD : ${lib.makeLibraryPath [ libdvdcss ]}/libdvdcss.so
  '';

  inherit (brasero-original) meta;
}

{ lib, symlinkJoin, brasero-original, cdrtools, makeWrapper }:

let
  binPath = lib.makeBinPath [ cdrtools ];
in symlinkJoin {
  name = "brasero-${brasero-original.version}";

  paths = [ brasero-original ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/brasero \
      --prefix PATH ':' ${binPath}
  '';
}

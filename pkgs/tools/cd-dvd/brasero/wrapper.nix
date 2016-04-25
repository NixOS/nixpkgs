{ lib, buildEnv, brasero-original, cdrtools, makeWrapper }:

let
  binPath = lib.makeBinPath [ cdrtools ];
in buildEnv {
  name = "brasero-${brasero-original.version}";

  paths = [ brasero-original ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${brasero-original}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/brasero \
      --prefix PATH ':' ${binPath}
  '';
}

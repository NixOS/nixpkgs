{ stdenvNoCC, mmdoc }:

stdenvNoCC.mkDerivation rec {
  name = "nixos-minimal-manual";

  src = builtins.filterSource (path: type: type == "directory" || builtins.match ".*\.md" path == [] || builtins.match ".*\.dot" path == []) ../../../../nixos/doc/manual;

  phases = [ "buildPhase" ];

  buildPhase = ''
    cp -r $src doc
    chmod -R u+w doc
    cp ${./toc.md} doc/toc.md
    ${mmdoc}/bin/mmdoc nixos doc $out
  '';
}

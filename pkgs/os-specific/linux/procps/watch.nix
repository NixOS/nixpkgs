{ stdenv, procps-ng }:

stdenv.mkDerivation {
  name = "watch-${procps-ng.version}";

  unpackPhase = "true";

  installPhase = "install -D ${procps-ng}/bin/watch $out/bin/watch";

  meta = {
    homepage = https://sourceforge.net/projects/procps/;
    description = "Utility for watch the output of a given command at intervals";
    inherit (procps-ng.meta) platforms;
  };
}

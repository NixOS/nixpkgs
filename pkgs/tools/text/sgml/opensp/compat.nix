{ stdenv, opensp }:

stdenv.mkDerivation {
  name = "sp-compat-${stdenv.lib.getVersion opensp}";

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -pv $out/bin
    for i in ${opensp}/bin/o*; do
      ln -sv $i $out/bin/''${i#${opensp}/bin/o}
    done
    '';

  setupHook = opensp.setupHook;

  meta = opensp.meta // {
    description = "Compatibility wrapper for old programs looking for original sp programs";
    platforms = stdenv.lib.platforms.unix;
  };
}

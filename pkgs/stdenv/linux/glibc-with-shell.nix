{ stdenv, bash, glibc, patchelf }:

stdenv.mkDerivation {
  inherit (glibc) name;

  buildInputs = [ patchelf ];

  buildCommand = ''
    mkdir -p $out
    tar -c -C ${glibc} . | \
      sed "s@${glibc}@$out@g" | \
      tar -x -C $out
    chmod +w -R $out
    unlink $out/bin/sh
    tar -c -C ${bash} . | \
      sed -e "s@${glibc}@$out@g" -e "s@${bash}@$out@g" | \
      tar -x -C $out
    patchELF $out
    fixupPhase
  '';
}

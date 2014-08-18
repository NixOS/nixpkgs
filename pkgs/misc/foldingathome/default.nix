{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "folding-at-home-6.02";

  src = fetchurl {
    url = http://www.stanford.edu/group/pandegroup/folding/release/FAH6.02-Linux.tgz;
    sha256 = "01nwi0lb4vv0xg4k04i2fbf5v5qgabl70jm5cgvw1ibgqjz03910";
  };

  unpackPhase = "tar xvzf $src";

  # Otherwise it doesn't work at all, even ldd thinks it's not a dynamic executable
  dontStrip = true;

  # This program, to run with '-smp', wants to execute the program mpiexec
  # as "./mpiexec", although it also expects to write the data files into "."
  # I suggest, if someone wants to run it, in the data directory set a link
  # to the store for 'mpiexec', so './mpiexec' will work. That link better
  # be considered a gcroot.
  installPhase = ''
    BINFILES="fah6 mpiexec";
    for a in $BINFILES; do 
      patchelf --set-interpreter $(cat $NIX_GCC/nix-support/dynamic-linker) $a
    done
    mkdir -p $out/bin
    cp $BINFILES $out/bin
  '';

  meta = {
    homepage = http://folding.stanford.edu/;
    description = "Folding@home distributed computing client";
    license = "unfree";
  };
}

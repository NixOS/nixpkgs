{ stdenv, fetchurl, perl, mktemp, module_init_tools

  # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
, kernelPatches ? []
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation {
  name = "linux-2.6.19.2";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.19.2.tar.bz2;
    sha256 = "02sl38spz1iwlwdajmnyw6wi55sdc7j12n5k31bz5l8klv554p65";
  };
  
  patches = map (p: p.patch) kernelPatches;

  config =
    if stdenv.system == "i686-linux" then ./config-2.6.19.2-i686-smp else
    if stdenv.system == "x86_64-linux" then ./config-2.6.19.2-x86_64-smp else
    abort "No kernel configuration for your platform!";
  
  buildInputs = [perl mktemp];
  
  arch =
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    abort "";

  inherit module_init_tools;

  meta = {
    description =
      "The Linux kernel" +
      (if kernelPatches == [] then "" else
        " (with patches: "
        + (let lib = import ../../../lib;
          in lib.concatStrings (lib.intersperse ", " (map (x: x.name) kernelPatches)))
        + ")");
  };
}

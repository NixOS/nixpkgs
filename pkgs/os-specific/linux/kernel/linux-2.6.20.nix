{ stdenv, fetchurl, perl, mktemp, module_init_tools

  # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
, kernelPatches ? []
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let lib = import ../../../lib; in

stdenv.mkDerivation {
  name = "linux-2.6.20.2";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.20.2.tar.bz2;
    sha256 = "0wmq9vzj89rbfpxi79qgbjxl6f5dv2crlg65f1cncc4m898nxi2n";
  };
  
  patches = map (p: p.patch) kernelPatches;
  extraConfig = lib.concatStrings (map (p: "\n" + p.extraConfig + "\n") kernelPatches);

  config =
    if stdenv.system == "i686-linux" then ./config-2.6.20-i686-smp else
    if stdenv.system == "x86_64-linux" then ./config-2.6.20-x86_64-smp else
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
        + lib.concatStrings (lib.intersperse ", " (map (x: x.name) kernelPatches))
        + ")");
  };
}

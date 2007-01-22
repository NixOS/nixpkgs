{ stdenv, fetchurl, perl, mktemp, module_init_tools

  # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
, kernelPatches ? []
}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.19.1";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.19.1.tar.bz2;
    md5 = "2ab08fdfddc00e09b3d5bc7397d3c8be";
  };
  
  patches = map (p: p.patch) kernelPatches;

  config = ./config-2.6.19.1-i686-up;
  
  buildInputs = [perl mktemp];
  arch="i386";

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

{ stdenv, fetchurl, perl, mktemp, module_init_tools

  # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
, kernelPatches ? []
}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.18.3";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.3.tar.bz2;
    md5 = "fb10bd4918f22f349131af0b5121b70e";
  };
  
  patches = map (p: p.patch) kernelPatches;

  config = ./config-2.6.18.1-up;
  
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

{ stdenv, fetchurl, perl, mktemp

  # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
, kernelPatches ? []
}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.18.1";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.1.tar.bz2;
    md5 = "38f00633b02f07819d17bcd87d03eb3a";
  };
  
  patches = map (p: p.patch) kernelPatches;

  config = ./config-2.6.18.1-up;
  
  buildInputs = [perl mktemp];
  arch="i386";

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

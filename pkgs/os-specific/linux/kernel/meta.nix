args: with args;

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let

  lib = stdenv.lib;
  addNewlines = map (s: "\n" + s + "\n");
  kernelPatches = systemPatches ++ extraPatches;

in

stdenv.mkDerivation {
  name = if userModeLinux then "user-mode-linux-${version}" else "linux-${version}";
  builder = ./builder.sh;
  
  src = fetchurl ( {
    url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
  } // src_hash );
  
  patches = map (p: p.patch) kernelPatches;

  extraConfig =
    let configFromPatches =
          map (p: if p ? extraConfig then p.extraConfig else "") kernelPatches;
    in lib.concatStrings (addNewlines (configFromPatches ++ extraConfig));

  config = configFile;
  
  buildInputs = [perl mktemp];
  
  arch =
    if userModeLinux then "um" else
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    abort "Platform ${stdenv.system} is not supported.";

  makeFlags = if userModeLinux then "ARCH=um SHELL=bash" else "";

  inherit module_init_tools;

  allowLocalVersion = false; # don't allow patches to set a suffix
  inherit localVersion; # but do allow the user to set one.

  meta = {
    description =
      (if userModeLinux then
        "User-Mode Linux"
       else
        "The Linux kernel") +
      (if kernelPatches == [] then "" else
        " (with patches: "
        + lib.concatStrings (lib.intersperse ", " (map (x: x.name) kernelPatches))
        + ")");
  };
}

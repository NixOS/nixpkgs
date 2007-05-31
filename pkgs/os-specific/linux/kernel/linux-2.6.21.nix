{ stdenv, fetchurl, perl, mktemp, module_init_tools

  # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
, kernelPatches ? []

, # Whether to build a User-Mode Linux kernel.
  userModeLinux ? false

, # Allows you to set your own kernel version suffix (e.g.,
  # "-my-kernel").
  localVersion ? ""

, # Your own kernel configuration file, if you don't want to use the
  # default. 
  kernelConfig ? null  
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let

  lib = import ../../../lib;

  version = "2.6.21.3";

in

stdenv.mkDerivation {
  name = if userModeLinux then "user-mode-linux-${version}" else "linux-${version}";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-${version}.tar.bz2";
    sha256 = "17rxvw42z4amijb8nya54c2h6bb8gnxnr628arv8shmsccf8qsp5";
  };
  
  patches = map (p: p.patch) kernelPatches;
  extraConfig = lib.concatStrings (map (p: "\n" + (if p ? extraConfig then p.extraConfig else "") + "\n") kernelPatches);

  config =
    if kernelConfig != null then kernelConfig else
    if userModeLinux then ./config-2.6.21-uml else
    if stdenv.system == "i686-linux" then ./config-2.6.21-i686-smp else
    if stdenv.system == "x86_64-linux" then ./config-2.6.21-x86_64-smp else
    abort "No kernel configuration for your platform!";
  
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

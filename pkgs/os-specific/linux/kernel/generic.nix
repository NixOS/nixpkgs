{ stdenv, fetchurl, perl, mktemp, module_init_tools

, # The kernel source tarball.
  src

, # The kernel version.
  version

, # The kernel configuration.
  config

, # An attribute set whose attributes express the availability of
  # certain features in this kernel.  E.g. `{iwlwifi = true;}'
  # indicates a kernel that provides Intel wireless support.  Used in
  # NixOS to implement kernel-specific behaviour.
  features ? {}

, # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
  kernelPatches ? []

, # Whether to build a User-Mode Linux kernel.
  userModeLinux ? false

, # Whether to build a Xen kernel.
  xen ? false

, # Allows you to set your own kernel version suffix (e.g.,
  # "-my-kernel").
  localVersion ? ""

, preConfigure ? ""
, extraMeta ? {}
, platform ? { name = "pc"; uboot = null; kernelBaseConfig = "defconfig"; }
, ...
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
  || stdenv.system == "armv5tel-linux";

assert platform.name == "sheevaplug" -> platform.uboot != null;
assert (platform.name == "sheevaplug" || platform.name == "versatileARM") ->
  stdenv.system == "armv5tel-linux";

let

  lib = stdenv.lib;

in

stdenv.mkDerivation {
  name = if userModeLinux then "user-mode-linux-${version}" else "linux-${version}";

  passthru = {
    inherit version;
    # Combine the `features' attribute sets of all the kernel patches.
    features = lib.fold (x: y: (if x ? features then x.features else {}) // y) features kernelPatches;
  };
  
  builder = ./builder.sh;

  generateConfig = ./generate-config.pl;

  inherit preConfigure src module_init_tools localVersion;

  patches = map (p: p.patch) kernelPatches;

  kernelConfig =
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([config] ++ configFromPatches);

  # For UML and non-PC, just ignore all options that don't apply (We are lazy).
  ignoreConfigErrors = (userModeLinux || stdenv.system == "armv5tel-linux");

  buildInputs = [ perl mktemp ]
    ++ lib.optional (platform.uboot != null) [platform.uboot];

  platformName = platform.name;
  kernelBaseConfig = platform.kernelBaseConfig;
  
  arch =
    if xen then "xen" else
    if userModeLinux then "um" else
    if platform ? kernelArch then platform.kernelArch else
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    abort "Platform ${stdenv.system} is not supported.";

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
  } // extraMeta;
}

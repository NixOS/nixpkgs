{ stdenv, fetchurl, perl, mktemp, module_init_tools

, # The kernel source tarball.
  src

, # The kernel version.
  version

, # The kernel configuration.
  config

, # The kernel configuration when cross building.
  configCross ? {}

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
, ubootChooser ? null
, ...
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
  || stdenv.system == "armv5tel-linux";

assert stdenv.platform.name == "sheevaplug" -> stdenv.platform.uboot != null;

let

  lib = stdenv.lib;

  kernelConfigFun = baseConfig:
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([baseConfig] ++ configFromPatches);

in

stdenv.mkDerivation {
  name = if userModeLinux then "user-mode-linux-${version}" else "linux-${version}";

  enableParallelBuilding = true;

  passthru = {
    inherit version;
    # Combine the `features' attribute sets of all the kernel patches.
    features = lib.fold (x: y: (if x ? features then x.features else {}) // y) features kernelPatches;
  };
  
  builder = ./builder.sh;

  generateConfig = ./generate-config.pl;

  inherit preConfigure src module_init_tools localVersion;

  patches = map (p: p.patch) kernelPatches;

  kernelConfig = kernelConfigFun config;

  # For UML and non-PC, just ignore all options that don't apply (We are lazy).
  ignoreConfigErrors = (userModeLinux || stdenv.platform.name != "pc");

  buildNativeInputs = [ perl mktemp ];
  buildInputs = lib.optional (stdenv.platform.uboot != null)
    (ubootChooser stdenv.platform.uboot);

  platformName = stdenv.platform.name;
  kernelBaseConfig = stdenv.platform.kernelBaseConfig;
  kernelTarget = stdenv.platform.kernelTarget;
  autoModules = stdenv.platform.kernelAutoModules;
  
  # Should we trust platform.kernelArch? We can only do
  # that once we differentiate i686/x86_64 in platforms.
  arch =
    if xen then "xen" else
    if userModeLinux then "um" else
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "armv5tel-linux" then "arm" else
    abort "Platform ${stdenv.system} is not supported.";

  crossAttrs = let
      cp = stdenv.cross.platform;
    in
      assert cp.name == "sheevaplug" -> cp.uboot != null;
    {
      arch = cp.kernelArch;
      platformName = cp.name;
      kernelBaseConfig = cp.kernelBaseConfig;
      kernelTarget = cp.kernelTarget;
      autoModules = cp.kernelAutoModules;

      # Just ignore all options that don't apply (We are lazy).
      ignoreConfigErrors = true;

      kernelConfig = kernelConfigFun configCross;

      # The substitution of crossAttrs happens *after* the stdenv cross adapter sets
      # the parameters for the usual stdenv. Thus, we need to specify
      # the ".hostDrv" in the buildInputs here.
      buildInputs = lib.optional (cp.uboot != null) (ubootChooser cp.uboot).hostDrv;
    };

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
    license = "GPLv2";
    homepage = http://www.kernel.org/;
    maintainers = [ lib.maintainers.eelco ];
  } // extraMeta;
}

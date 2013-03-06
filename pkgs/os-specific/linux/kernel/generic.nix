{ stdenv, fetchurl, perl, mktemp, module_init_tools

, # The kernel source tarball.
  src

, # The kernel version.
  version

, # The version number used for the module directory
  modDirVersion ? version

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

, # Allows you to set your own kernel version suffix (e.g.,
  # "-my-kernel").
  localVersion ? ""

, preConfigure ? ""
, extraMeta ? {}
, ubootChooser ? null
, postInstall ? ""

, # After the builder did a 'make all' (kernel + modules)
  # we force building the target asked: bzImage/zImage/uImage/...
  postBuild ? "make $makeFlags $kernelTarget; make $makeFlags -C scripts unifdef"

, extraBuildNativeInputs ? []
, ...
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
  || stdenv.isArm || stdenv.system == "mips64el-linux";

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
  name = "linux-${version}";

  enableParallelBuilding = true;

  passthru = {
    inherit version modDirVersion kernelPatches;
    # Combine the `features' attribute sets of all the kernel patches.
    features = lib.fold (x: y: (if x ? features then x.features else {}) // y) features kernelPatches;
  };

  builder = ./builder.sh;

  generateConfig = ./generate-config.pl;

  inherit preConfigure src module_init_tools localVersion postInstall postBuild;

  patches = map (p: p.patch) kernelPatches;

  kernelConfig = kernelConfigFun config;

  # For UML and non-PC, just ignore all options that don't apply (We are lazy).
  ignoreConfigErrors = stdenv.platform.name != "pc";

  buildNativeInputs = [ perl mktemp ] ++ extraBuildNativeInputs;
  buildInputs = lib.optional (stdenv.platform.uboot != null)
    (ubootChooser stdenv.platform.uboot);

  platformName = stdenv.platform.name;
  kernelBaseConfig = stdenv.platform.kernelBaseConfig;
  kernelTarget = stdenv.platform.kernelTarget;
  autoModules = stdenv.platform.kernelAutoModules;

  # Should we trust platform.kernelArch? We can only do
  # that once we differentiate i686/x86_64 in platforms.
  arch =
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.isArm then "arm" else
    if stdenv.system == "mips64el-linux" then "mips" else
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
      "The Linux kernel" +
      (if kernelPatches == [] then "" else
        " (with patches: "
        + lib.concatStrings (lib.intersperse ", " (map (x: x.name) kernelPatches))
        + ")");
    inherit version;
    license = "GPLv2";
    homepage = http://www.kernel.org/;
    maintainers = [
      lib.maintainers.eelco
      lib.maintainers.chaoflow
    ];
    platforms = lib.platforms.linux;
  } // extraMeta;
}


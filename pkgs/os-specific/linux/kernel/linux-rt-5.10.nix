{ lib, buildLinux, fetchurl
, kernelPatches ? [ ]
, structuredExtraConfig ? {}
, extraMeta ? {}
, argsOverride ? {}
, ... } @ args:

let
  version = "5.10.219-rt111"; # updated by ./update-rt.sh
  branch = lib.versions.majorMinor version;
  kversion = builtins.elemAt (lib.splitString "-" version) 0;
in buildLinux (args // {
  inherit version;
  pname = "linux-rt";

  # modDirVersion needs a patch number, change X.Y-rtZ to X.Y.0-rtZ.
  modDirVersion = lib.versions.pad 3 version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "0c6dhi6w8likvyyzw7wj2fqhz8nhv760kkic8bk66r1prhakzdwk";
  };

  kernelPatches = let rt-patch = {
    name = "rt";
    patch = fetchurl {
      url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
      sha256 = "0imnwj8210cjvmr90yhcc0nn80s3wlc5n2cdrnbg72lm4dny2qpn";
    };
  }; in [ rt-patch ] ++ kernelPatches;

  structuredExtraConfig = with lib.kernel; {
    PREEMPT_RT = yes;
    # Fix error: unused option: PREEMPT_RT.
    EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt)
    # Fix error: option not set correctly: PREEMPT_VOLUNTARY (wanted 'y', got 'n').
    PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
    # Fix error: unused option: RT_GROUP_SCHED.
    RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
  } // structuredExtraConfig;

  extraMeta = extraMeta // {
    inherit branch;
  };
} // argsOverride)

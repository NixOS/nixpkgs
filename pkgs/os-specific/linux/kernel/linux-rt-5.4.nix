{ lib, buildLinux, fetchurl
, kernelPatches ? [ ]
, structuredExtraConfig ? {}
, extraMeta ? {}
, argsOverride ? {}
, ... } @ args:

let
  version = "5.4.106-rt54"; # updated by ./update-rt.sh
  branch = lib.versions.majorMinor version;
  kversion = builtins.elemAt (lib.splitString "-" version) 0;
in buildLinux (args // {
  inherit version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "1ny8b69ngydh0iw53jwlmqlgv31wjhkybkgnqi5kv0n174n3p1yc";
  };

  kernelPatches = let rt-patch = {
    name = "rt";
    patch = fetchurl {
      url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
      sha256 = "0xwbpn1k1b4bxq15sw7gicrzkfg32nkja308a5pcwx1ihv9khchf";
    };
  }; in [ rt-patch ] ++ lib.remove rt-patch kernelPatches;

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

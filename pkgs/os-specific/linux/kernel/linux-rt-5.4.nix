{ lib, buildLinux, fetchurl
, kernelPatches ? [ ]
, structuredExtraConfig ? {}
, extraMeta ? {}
, argsOverride ? {}
, ... } @ args:

let
<<<<<<< HEAD
  version = "5.4.254-rt85"; # updated by ./update-rt.sh
=======
  version = "5.4.242-rt81"; # updated by ./update-rt.sh
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  branch = lib.versions.majorMinor version;
  kversion = builtins.elemAt (lib.splitString "-" version) 0;
in buildLinux (args // {
  inherit version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
<<<<<<< HEAD
    sha256 = "1iyrm2xql15ifhy2b939ywrrc44yd41b79sjjim4vqxmc6lqsq2i";
=======
    sha256 = "0a7wfi84p74qsnbj1vamz4qxzp94v054jp1csyfl0blz3knrlbql";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  kernelPatches = let rt-patch = {
    name = "rt";
    patch = fetchurl {
      url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
<<<<<<< HEAD
      sha256 = "0vq5lrqqy7yspznbbkla2cjakz7w1n8qvg31a856qs6abynwrw6x";
=======
      sha256 = "1wszhzw9ic018x3jiz8x1ffxxg30wpy4db7hja44b661p9fjm1dc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

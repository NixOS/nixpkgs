{
  lib,
  buildLinux,
  fetchurl,
  kernelPatches ? [ ],
  structuredExtraConfig ? { },
  extraMeta ? { },
  argsOverride ? { },
  ...
}@args:

let
  version = "6.1.158-rt58"; # updated by ./update-rt.sh
  branch = lib.versions.majorMinor version;
  kversion = builtins.elemAt (lib.splitString "-" version) 0;
in
buildLinux (
  args
  // {
    inherit version;
    pname = "linux-rt";

    # modDirVersion needs a patch number, change X.Y-rtZ to X.Y.0-rtZ.
    modDirVersion =
      if (builtins.match "[^.]*[.][^.]*-.*" version) == null then
        version
      else
        lib.replaceStrings [ "-" ] [ ".0-" ] version;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${kversion}.tar.xz";
      hash = "sha256-rQaL/bYE7A9PfeOFyOerlEAIqnikruypT1Mgbmcmv9o=";
    };

    kernelPatches =
      let
        rt-patch = {
          name = "rt";
          patch = fetchurl {
            url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
            hash = "sha256-Ws250UnJ8Il9d4j5KerKwia5X19b3kM4NifMo3/ydGE=";
          };
        };
      in
      [ rt-patch ] ++ kernelPatches;

    structuredExtraConfig =
      with lib.kernel;
      {
        PREEMPT_RT = yes;
        # Fix error: unused option: PREEMPT_RT.
        EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt)
        # Fix error: option not set correctly: PREEMPT_VOLUNTARY (wanted 'y', got 'n').
        PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
        # Fix error: unused option: RT_GROUP_SCHED.
        RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
      }
      // structuredExtraConfig;

    extraMeta = extraMeta // {
      inherit branch;
    };

    isLTS = true;
  }
  // argsOverride
)

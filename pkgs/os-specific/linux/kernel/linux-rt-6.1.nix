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
  version = "6.1.119-rt45"; # updated by ./update-rt.sh
  branch = lib.versions.majorMinor version;
  kversion = builtins.elemAt (lib.splitString "-" version) 0;
in
buildLinux (
  args
  // {
    inherit version;

    # modDirVersion needs a patch number, change X.Y-rtZ to X.Y.0-rtZ.
    modDirVersion =
      if (builtins.match "[^.]*[.][^.]*-.*" version) == null then
        version
      else
        lib.replaceStrings [ "-" ] [ ".0-" ] version;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${kversion}.tar.xz";
      sha256 = "0y1j8bz99d5vkxklzpwhns5r77lpz2prszf6whfahi58s0wszkdf";
    };

    kernelPatches =
      let
        rt-patch = {
          name = "rt";
          patch = fetchurl {
            url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
            sha256 = "0a7qga7xadp9ghhzz4iifdhap7vm288b789mv0xr9y8gnnk7cc9m";
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
  }
  // argsOverride
)

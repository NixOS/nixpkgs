{
  kmod,
  modules,
  buildEnv,
  name ? "kernel-modules",
}:

buildEnv {
  inherit name;

  paths = modules;

  pathsToLink = [
    "/lib/modules"
    "/etc/depmod.d"
  ];

  postBuild = ''
    (
      shopt -s nullglob extglob

      kernelVersions=("$out"/lib/modules/*)
      kernelVersions=("''${kernelVersions[@]#"$out"/lib/modules/}")

      if [ ''${#kernelVersions[@]} -eq 0 ]; then
        echo "No modules found. Skipping depmod and module certificate merging."
        exit
      elif [ ''${#kernelVersions[@]} -gt 1 ]; then
        echo "Failing because lib/modules contains more than one kernel version: $(IFS=', ' && echo "''${kernelVersions[*]}")" >&2
        exit 1
      fi

      kernelVersion="''${kernelVersions[0]}"

      echo "Kernel version: $kernelVersion"

      modulesDir="$out/lib/modules/$kernelVersion"

      # When there is one input path that contains a lib/modules/$kernelVersion
      # directory, $modulesDir is a symlink to that directory and is not
      # writable. In this case, there is no need to run depmod and to recreate
      # modules.cer.
      if [ -w "$modulesDir" ]; then
        echo "Module directories from multiple input paths were merged. Running depmod and merging module certificates..."

        cd -- "$modulesDir"

        # eval lets bash parse the code with extglob enable.
        eval 'rm -f modules.!(builtin*|order*|cer)'

        # Regenerate the depmod map files. Be sure to pass an explicit
        # kernel version number, otherwise depmod will use `uname -r'.
        ${kmod}/bin/depmod -b "$out" -C "$out/etc/depmod.d" -a "$kernelVersion"

        # Merge the single‐module certificates for external modules.
        cp --no-preserve=mode,ownership --remove-destination \
          -- "$(readlink -f modules.cer)" modules.cer
        sed "1,$(wc -l < modules.order)d; s/\.ko.*/.ko.cer/" modules.dep \
            | xargs -d'\n' cat >> modules.cer
      fi
    )
  '';
}

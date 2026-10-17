{
  stdenvNoCC,
  kmod,
  modules,
  buildEnv,
  name ? "kernel-modules",
}:

buildEnv {
  inherit name;

  paths = modules;

  postBuild = ''
    source ${stdenvNoCC}/setup

    if ! test -d "$out/lib/modules"; then
      echo "No modules found."
      # To support a kernel without modules
      exit 0
    fi

    kernelVersion=$(cd $out/lib/modules && ls -d *)
    if test "$(echo $kernelVersion | wc -w)" != 1; then
       echo "inconsistent kernel versions: $kernelVersion"
       exit 1
    fi

    echo "kernel version is $kernelVersion"

    shopt -s extglob

    # Regenerate the depmod map files.  Be sure to pass an explicit
    # kernel version number, otherwise depmod will use `uname -r'.
    if test -w $out/lib/modules/$kernelVersion; then
        rm -f $out/lib/modules/$kernelVersion/modules.!(builtin*|order*|cer)
        ${kmod}/bin/depmod -b $out -C $out/etc/depmod.d -a $kernelVersion
        cd -- "$out/lib/modules/$kernelVersion"

        # Merge the single‐module certificates for external modules.
        cp --no-preserve=mode,ownership --remove-destination \
          -- "$(readlink -f modules.cer)" modules.cer
        sed "1,$(wc -l < modules.order)d; s/\.ko.*/.ko.cer/" modules.dep \
            | xargs -d'\n' cat >> modules.cer
    fi
  '';
}

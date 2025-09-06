{
  stdenvNoCC,
  kmod,
  modules,
  buildEnv,
  callPackage,
  kernelVersion,
  name ? "kernel-modules",
  depmodConfig ? null,
}:
let
  depmodConfFile = callPackage ./depmod-config-generator.nix {
    inherit modules kernelVersion depmodConfig;
  };
in
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

    cp ${depmodConfFile} $out/lib/modules/$kernelVersion/depmod.conf

    # Regenerate the depmod map files.  Be sure to pass an explicit
    # kernel version number, otherwise depmod will use `uname -r'.
    if test -w $out/lib/modules/$kernelVersion; then
        rm -f $out/lib/modules/$kernelVersion/modules.!(builtin*|order*)
        ${kmod}/bin/depmod --config ${depmodConfFile} -b $out -a $kernelVersion
    fi
  '';
}

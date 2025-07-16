{
  stdenvNoCC,
  lib,
  kmod,
  modules,
  buildEnv,
  writeTextFile,
  kernelVersion,
  name ? "kernel-modules",
  depmodConfig ? null,
}:
let
  getRelativeOverridePath =
    entry:
    let
      # check if the modulePath is inside the aggregator environmnet. If not, throw an error
      checkModuleExists =
        x:
        lib.throwIf
          (
            (lib.lists.findFirst (
              a:
              lib.path.hasPrefix (/. + builtins.unsafeDiscardStringContext a.outPath) (
                /. + builtins.unsafeDiscardStringContext x.modulePackage
              )
            ) null modules) == null
          )
          "The modulePath for your ${x.moduleName} depmod override is not available. Add ${x.modulePackage} to `boot.extraModulePackages`."
          (checkModuleRelativePathIsInStore x);

      checkModuleRelativePathIsInStore =
        x:
        let
          moduleStorePath = "${x.modulePackage}" + "/lib/modules/${kernelVersion}" + "/${x.modulePath}";
        in
        lib.throwIfNot (builtins.pathExists moduleStorePath) "${moduleStorePath} does not exist in store" x;
    in
    (checkModuleExists entry).modulePath;

  genDepmodConfOverridesList = builtins.map (
    x: "override ${x.moduleName} * ${getRelativeOverridePath x}"
  ) depmodConfig.overrides;

  depmodConfFile = writeTextFile {
    name = "depmod.conf";
    text = lib.optionalString (!(builtins.isNull depmodConfig)) (
      builtins.concatStringsSep "\n" genDepmodConfOverridesList
    );

    preferLocalBuild = true;
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

{
  lib,
  modules,
  writeTextFile,
  kernelVersion,
  depmodConfig ? null,
}:
#####
# Create a depmod config file.
# During the creation check if the entries are valid. If not throw an error
#####
let
  getRelativeOverridePath =
    entry:
    let
      # check if the modulePath is inside the aggregator environment (`modules`). If not, throw an error as the depmod reference is not possible
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

      # check if the set modulePath of an entry exists in the aggregator environment (`modules`). If not, throw an error
      checkModuleRelativePathIsInStore =
        x:
        let
          moduleStorePath = "${x.modulePackage}" + "/lib/modules/${kernelVersion}" + "/${x.modulePath}";
        in
        lib.throwIfNot (builtins.pathExists moduleStorePath) "${moduleStorePath} does not exist in store" x;
    in
    (checkModuleExists entry).modulePath;

  # create a list of depmod override config lines
  genDepmodConfOverridesList = builtins.map (
    x: "override ${x.moduleName} * ${getRelativeOverridePath x}"
  ) depmodConfig.overrides;
in
writeTextFile {
  name = "depmod.conf";
  text = lib.optionalString (!(builtins.isNull depmodConfig)) (
    builtins.concatStringsSep "\n" genDepmodConfOverridesList
  );

  preferLocalBuild = true;
}

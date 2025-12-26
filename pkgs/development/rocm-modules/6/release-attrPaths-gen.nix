{
  variant,
}:
let
  pkgs = import ../../../../. { config.allowAliases = false; };
  lib = pkgs.lib;
  optionalsWithSuccess =
    toTry: next:
    let
      tried = builtins.tryEval toTry;
    in
    lib.optionals tried.success (next tried.value);
  findAll =
    path: obj:
    optionalsWithSuccess obj (
      obj:
      if obj ? outPath then
        optionalsWithSuccess obj.outPath or null (
          outPath:
          # filter out unavailable, broken packages, and drvs with broken deps
          lib.optional (!((obj ? meta) && (!obj.meta.available or false || obj.meta.broken))) {
            p = path;
            o = outPath;
          }
        )
      else if (obj.recurseForDerivations or false) || (obj.recurseForRelease or false) then
        lib.concatLists (
          lib.mapAttrsToList (
            name: value: findAll (if path == null then name else path + "." + name) value
          ) obj
        )
      else
        [ ]
    );
in
findAll null (pkgs.${variant} // { recurseForDerivations = true; })

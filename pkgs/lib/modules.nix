# NixOS module handling.

let lib = import ./default.nix; in

with { inherit (builtins) head tail; };
with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;
with import ./properties.nix;

rec {

  # Unfortunately this can also be a string.
  isPath = x: !(
     builtins.isFunction x
  || builtins.isAttrs x
  || builtins.isInt x
  || builtins.isBool x
  || builtins.isList x
  );

  importIfPath = path:
    if isPath path then
      import path
    else
      path;

  applyIfFunction = f: arg:
    if builtins.isFunction f then
      f arg
    else
      f;

  moduleClosure = initModules: args:
    let
      moduleImport = m:
        (applyIfFunction (importIfPath m) args) // {
          # used by generic closure to avoid duplicated imports.
          key = m;
        };

      removeKeys = list: map (m: removeAttrs m ["key"]) list;

      getImports = m:
        if m ? config || m ? options then
          attrByPath ["imports"] [] m
        else
          toList (rmProperties (attrByPath ["require"] [] (delayProperties m)));

      getImportedPaths = m: filter isPath (getImports m);
      getImportedSets = m: filter (x: !isPath x) (getImports m);

      inlineImportedSets = list:
        lib.concatMap (m:[m] ++ map moduleImport (getImportedSets m)) list;
    in
      removeKeys (inlineImportedSets (lazyGenericClosure {
        startSet = map moduleImport initModules;
        operator = m: map moduleImport (getImportedPaths m);
      }));

  selectDeclsAndDefs = modules:
    lib.concatMap (m:
      if m ? config || m ? options then
         attrByPath ["options"] [] m
      ++ attrByPath ["config"] [] m
      else
        [ m ]
    ) modules;

}
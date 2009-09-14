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

  # Convert module to a set which has imports / options and config
  # attributes.
  unifyModuleSyntax = m:
    let
      getImports = m:
        if m ? config || m ? options then
          attrByPath ["imports"] [] m
        else
          toList (rmProperties (attrByPath ["require"] [] (delayProperties m)));

      getImportedPaths = m: filter isPath (getImports m);
      getImportedSets = m: filter (x: !isPath x) (getImports m);

      getConfig = m:
        removeAttrs (delayProperties m) ["require"];
    in
      if m ? config || m ? options then
        m
      else
        {
          imports = getImportedPaths m;
          config = getConfig m;
        } // (
          if getImportedSets m != [] then
            assert tail (getImportedSets m) == [];
            { options = head (getImportedSets m); }
          else
            {}
        );

  moduleClosure = initModules: args:
    let
      moduleImport = m: lib.addErrorContext 
        "Import module ${(if builtins.isAttrs m then "{...}" else m)}." (
        (unifyModuleSyntax (applyIfFunction 
	  (if builtins.isAttrs m then m else import m) args)) // {
          # used by generic closure to avoid duplicated imports.
          key = m;
          paths = [ m ];
        }
      );

      getImports = m: attrByPath ["imports"] [] m;
    in
      lazyGenericClosure {
        startSet = map moduleImport initModules;
        operator = m: map moduleImport (getImports m);
      };

  selectDeclsAndDefs = modules:
    lib.concatMap (m:
      if m ? config || m ? options then
         [ (attrByPath ["options"] {} m) ]
      ++ [ (attrByPath ["config"] {} m) ]
      else
        [ m ]
    ) modules;

}

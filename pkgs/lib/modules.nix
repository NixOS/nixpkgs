# NixOS module handling.

let lib = import ./default.nix; in

with { inherit (builtins) head tail; };
with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;
with import ./options.nix;
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

  isModule = m:
       (m ? config && isAttrs m.config && ! isOption m.config)
    || (m ? options && isAttrs m.options && ! isOption m.options);

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
      if isModule m then
        { key = "<unknown location>"; } // m
      else
        {
          key = "<unknown location>";
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
      moduleImport = m:
        (unifyModuleSyntax (applyIfFunction (importIfPath m) args)) // {
          # used by generic closure to avoid duplicated imports.
          key = if isPath m then m else "<unknown location>";
        };

      getImports = m: attrByPath ["imports"] [] m;

    in
      (lazyGenericClosure {
        startSet = map moduleImport (filter isPath initModules);
        operator = m: map moduleImport (getImports m);
      }) ++ (map moduleImport (filter (m: ! isPath m) initModules));

  selectDeclsAndDefs = modules:
    lib.concatMap (m:
      if m ? config || m ? options then
         [ (attrByPath ["options"] {} m) ]
      ++ [ (attrByPath ["config"] {} m) ]
      else
        [ m ]
    ) modules;


  moduleApply = funs: module:
    lib.mapAttrs (name: value:
      if builtins.hasAttr name funs then
        let fun = lib.getAttr name funs; in
        fun value
      else
        value
    ) module;

  delayModule = module:
    moduleApply { config = delayProperties; } module;

  selectModule = name: m:
    { inherit (m) key;
    } // (
      if m ? options && builtins.hasAttr name m.options then
        { options = lib.getAttr name m.options; }
      else {}
    ) // (
      if m ? config && builtins.hasAttr name m.config then
        { config = lib.getAttr name m.config; }
      else {}
    );

  filterModules = name: modules:
    filter (m: m ? config || m ? options) (
      map (selectModule name) modules
    );

  modulesNames = modules:
    lib.concatMap (m: []
    ++ optionals (m ? options) (lib.attrNames m.options)
    ++ optionals (m ? config) (lib.attrNames m.config)
    ) modules;

  moduleZip = funs: modules:
    lib.mapAttrs (name: fun:
      fun (
        map (lib.getAttr name) (
          filter (builtins.hasAttr name) modules
        )
      )
    ) funs;

  moduleMerge = path: modules:
    let modules_ = modules; in
    let
      addName = name:
        if path == "" then name else path + "." + name;

      modules = map delayModule modules_;

      modulesOf = name: filterModules name modules;
      declarationsOf = name: filter (m: m ? options) (modulesOf name);
      definitionsOf  = name: filter (m: m ? config ) (modulesOf name);

      recurseInto = name: modules:
        moduleMerge (addName name) (modulesOf name);

      recurseForOption = name: modules:
        moduleMerge name (
          map unifyModuleSyntax modules
        );

      errorSource = modules:
        "The error may come from the following files:\n" + (
          lib.concatStringsSep "\n" (
            map (m:
              if m ? key then toString m.key else "<unknown location>"
            ) modules
          )
        );

      eol = "\n";

      errDefinedWithoutDeclaration = name:
        let
          badModules =
            filter (m: ! isAttrs m.config)
              (definitionsOf name);
        in
          "${eol
          }Option '${addName name}' defined without option declaration.${eol
          }${errorSource badModules}${eol
          }";

      endRecursion =  { options = {}; config = {}; };

    in if modules == [] then endRecursion else

      lib.fix (result:
        moduleZip {
          options = lib.zip (name: values:
            if any isOption values then
              let
                # locations to sub-options declarations
                decls =
                  map (m:
                    mapSubOptions (subModule:
                      let module = lib.applyIfFunction subModule {}; in
                      if lib.isModule module then
                        { inherit (m) key; } // subModule
                      else
                        args: {
                          inherit (m) key;
                          options = lib.applyIfFunction subModule args;
                        }
                    ) m.options
                  ) (declarationsOf name);
              in
                addOptionMakeUp
                  { name = addName name; recurseInto = recurseForOption; }
                  (mergeOptionDecls decls)
                // {
                  declarations =
                    map (m: {
                      source = m.key;
                      value = m.options;
                    }) (declarationsOf name);
    
                  definitions =
                    map (m: {
                      source = m.key;
                      value = m.config;
                    }) (definitionsOf name);
                }
            else if all isAttrs values then
              (recurseInto name modules).options
            else
              throw "${eol
                }Unexpected type where option declarations are expected.${eol
                }${errorSource (declarationsOf name)}${eol
              }"
          );

          config = lib.zipWithNames (modulesNames modules) (name: values:
            let
              hasOpt = builtins.hasAttr name result.options;
              opt = lib.getAttr name result.options;

            in if hasOpt && isOption opt then
              let defs = evalProperties values; in
              lib.addErrorContext "${eol
                }while evaluating the option '${addName name}'.${eol
                }${errorSource (modulesOf name)}${eol
              }" (
                opt.apply (
                  if defs == [] then
                    if opt ? default then opt.default
                    else throw "Not defined."
                  else opt.merge defs
                )
              )

            else if hasOpt && lib.attrNames opt == [] then
              throw (errDefinedWithoutDeclaration name)

            else if any (v: isOption (rmProperties v)) values then
              let
                badModules =
                  filter (m: isOption m.config)
                    (definitionsOf name);
              in
                throw "${eol
                  }Option ${addName name} is defined in the configuration section.${eol
                  }${errorSource badModules}${eol
                }"

            else if all isAttrs values then
              (recurseInto name modules).config
            else
              throw (errDefinedWithoutDeclaration name)
          );

        } modules
      );

  fixMergeModules = initModules: {...}@args:
    lib.fix (result:
      # This trick avoid an infinite loop because names of attribute are
      # know and it is not require to evaluate the result of moduleMerge to
      # know which attribute are present as argument.
      let module = { inherit (result) options config; }; in

      moduleMerge "" (
        moduleClosure initModules (args // module)
      )
    );

}

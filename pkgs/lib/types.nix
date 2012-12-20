# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

let lib = import ./default.nix; in

with import ./lists.nix;
with import ./attrsets.nix;
with import ./options.nix;
with import ./trivial.nix;

rec {

  hasType = x: isAttrs x && x ? _type;
  typeOf = x: if hasType x then x._type else "";

  setType = typeName: value: value // {
    _type = typeName;
  };


  # name (name of the type)
  # check (boolean function)
  # merge (default merge function)
  # iter (iterate on all elements contained in this type)
  # fold (fold all elements contained in this type)
  # hasOptions (boolean: whatever this option contains an option set)
  # delayOnGlobalEval (boolean: should properties go through the evaluation of this option)
  # docPath (path concatenated to the option name contained in the option set)
  isOptionType = attrs: typeOf attrs == "option-type";
  mkOptionType =
    { name
    , check ? (x: true)
    , merge ? mergeDefaultOption
    # Handle complex structure types.
    , iter ? (f: path: v: f path v)
    , fold ? (op: nul: v: op v nul)
    , docPath ? lib.id
    # If the type can contains option sets.
    , hasOptions ? false
    , delayOnGlobalEval ? false
    }:

    { _type = "option-type";
      inherit name check merge iter fold docPath hasOptions delayOnGlobalEval;
    };


  types = rec {

    inferred = mkOptionType {
      name = "inferred type";
    };

    bool = mkOptionType {
      name = "boolean";
      check = lib.traceValIfNot builtins.isBool;
      merge = fold lib.or false;
    };

    int = mkOptionType {
      name = "integer";
      check = lib.traceValIfNot builtins.isInt;
    };

    string = mkOptionType {
      name = "string";
      check = lib.traceValIfNot builtins.isString;
      merge = lib.concatStrings;
    };

    envVar = mkOptionType {
      name = "environment variable";
      inherit (string) check;
      merge = lib.concatStringsSep ":";
    };

    attrs = mkOptionType {
      name = "attribute set";
      check = lib.traceValIfNot isAttrs;
      merge = fold lib.mergeAttrs {};
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "derivation";
      check = lib.traceValIfNot isDerivation;
    };

    path = mkOptionType {
      name = "path";
      # Hacky: there is no ‘isPath’ primop.
      check = lib.traceValIfNot (x: builtins.unsafeDiscardStringContext (builtins.substring 0 1 (toString x)) == "/");
    };

    listOf = types.list;
    list = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      check = value: lib.traceValIfNot isList value && all elemType.check value;
      merge = concatLists;
      iter = f: path: list: map (elemType.iter f (path + ".*")) list;
      fold = op: nul: list: lib.fold (e: l: elemType.fold op l e) nul list;
      docPath = path: elemType.docPath (path + ".*");
      inherit (elemType) hasOptions;

      # You cannot define multiple configurations of one entity, therefore
      # no reason justify to delay properties inside list elements.
      delayOnGlobalEval = false;
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
      check = x: lib.traceValIfNot isAttrs x
        && fold (e: v: v && elemType.check e) true (lib.attrValues x);
      merge = lib.zip (name: elemType.merge);
      iter = f: path: set: lib.mapAttrs (name: elemType.iter f (path + "." + name)) set;
      fold = op: nul: set: fold (e: l: elemType.fold op l e) nul (lib.attrValues set);
      docPath = path: elemType.docPath (path + ".<name>");
      inherit (elemType) hasOptions delayOnGlobalEval;
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertIfList = defIdx: def:
          if isList def then
            listToAttrs (
              flip imap def (elemIdx: elem:
                nameValuePair "unnamed-${toString defIdx}.${toString elemIdx}" elem))
          else
            def;
        listOnly = listOf elemType;
        attrOnly = attrsOf elemType;

      in mkOptionType {
        name = "list or attribute set of ${elemType.name}s";
        check = x:
          if isList x       then listOnly.check x
          else if isAttrs x then attrOnly.check x
          else lib.traceValIfNot (x: false) x;
        ## The merge function returns an attribute set
        merge = defs:
          attrOnly.merge (imap convertIfList defs);
        iter = f: path: def:
          if isList def       then listOnly.iter f path def
          else if isAttrs def then attrOnly.iter f path def
          else throw "Unexpected value";
        fold = op: nul: def:
          if isList def       then listOnly.fold op nul def
          else if isAttrs def then attrOnly.fold op nul def
          else throw "Unexpected value";

        docPath = path: elemType.docPath (path + ".<name?>");
        inherit (elemType) hasOptions delayOnGlobalEval;
      }
    ;

    uniq = elemType: mkOptionType {
      inherit (elemType) name check iter fold docPath hasOptions;
      merge = list:
        if length list == 1 then
          head list
        else
          throw "Multiple definitions. Only one is allowed for this option.";
    };

    none = elemType: mkOptionType {
      inherit (elemType) name check iter fold docPath hasOptions;
      merge = list:
        throw "No definitions are allowed for this option.";
    };

    nullOr = elemType: mkOptionType {
      inherit (elemType) name merge docPath hasOptions;
      check = x: builtins.isNull x || elemType.check x;
      iter = f: path: v: if v == null then v else elemType.iter f path v;
      fold = op: nul: v: if v == null then nul else elemType.fold op nul v;
    };

    functionTo = elemType: mkOptionType {
      name = "function that evaluates to a(n) ${elemType.name}";
      check = lib.traceValIfNot builtins.isFunction;
      merge = fns:
        args: elemType.merge (map (fn: fn args) fns)
      # These are guesses, I don't fully understand iter, fold, delayOnGlobalEval
      iter = f: path: v:
        args: elemType.iter f path (v args);
      fold = op: nul: v:
        args: elemType.fold op nul (v args);
      inherit (elemType) delayOnGlobalEval;
      hasOptions = false;
    };

    # !!! this should be a type constructor that takes the options as
    # an argument.
    optionSet = mkOptionType {
      name = "option set";
      # merge is done in "options.nix > addOptionMakeUp > handleOptionSets"
      merge = lib.id;
      check = x: isAttrs x || builtins.isFunction x;
      hasOptions = true;
      delayOnGlobalEval = true;
    };

  };

}

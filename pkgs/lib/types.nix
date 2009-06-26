# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

let lib = import ./default.nix; in

with import ./lists.nix;
with import ./attrsets.nix;
with import ./options.nix;

rec {

  hasType = x: isAttrs x && x ? _type;
  typeOf = x: if hasType x then x._type else "";

  
  # name (name of the type)
  # check (boolean function)
  # merge (default merge function)
  # iter (iterate on all elements contained in this type)
  # fold (fold all elements contained in this type)
  # hasOptions (boolean: whatever this option contains an option set)
  # path (path contatenated to the option name contained contained in the option set)
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
    }:

    { _type = "option-type";
      inherit name check merge iter fold docPath hasOptions;
    };

    
  types = {

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
      check = lib.traceValIfNot (x: builtins ? isString -> builtins.isString x);
      merge = lib.concatStrings;
    };

    attrs = mkOptionType {
      name = "attribute set";
      check = lib.traceValIfNot builtins.isAttrs;
      merge = fold lib.mergeAttrs {};
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "derivation";
      check = lib.traceValIfNot isDerivation;
    };

    list = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      check = value: lib.traceValIfNot isList value && all elemType.check value;
      merge = concatLists;
      iter = f: path: list: map (elemType.iter f (path + ".*")) list;
      fold = op: nul: list: lib.fold (e: l: elemType.fold op l e) nul list;
      docPath = path: elemType.docPath (path + ".*");
      inherit (elemType) hasOptions;
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType}s";
      check = x: lib.traceValIfNot builtins.isAttrs x
        && fold (e: v: v && elemType.check e) true (lib.attrValues x);
      merge = fold lib.mergeAttrs {};
      iter = f: path: set: lib.mapAttrs (name: elemType.iter f (path + "." + name)) set;
      fold = op: nul: set: fold (e: l: elemType.fold op l e) nul (lib.attrValues set);
      docPath = path: elemType.docPath (path + ".<name>");
      inherit (elemType) hasOptions;
    };

    uniq = elemType: mkOptionType {
      inherit (elemType) name check iter fold docPath hasOptions;
      merge = list:
        if tail list == [] then
          head list
        else
          throw "Multiple definitions. Only one is allowed for this option.";
    };

    nullOr = elemType: mkOptionType {
      inherit (elemType) name merge docPath hasOptions;
      check = x: builtins.isNull x || elemType.check x;
      iter = f: path: v: if v == null then v else elemType.iter f path v;
      fold = op: nul: v: if v == null then nul else elemType.fold op nul v;
    };

    optionSet = mkOptionType {
      name = "option set";
      check = x: lib.traceValIfNot builtins.isAttrs x;
      hasOptions = true;
    };

  };

}

{ lib }:
# Simple internal type checks for meta.
# This file is not a stable interface and may be changed arbitrarily.
#
# TODO: add a method to the module system types
#       see https://github.com/NixOS/nixpkgs/pull/273935#issuecomment-1854173100
let
  inherit (builtins)
    isString
    isInt
    isAttrs
    isList
    all
    any
    attrNames
    attrValues
    concatMap
    isFunction
    isBool
    concatStringsSep
    concatMapStringsSep
    isFloat
    elem
    mapAttrs
    ;
  isTypeDef = t: isAttrs t && t ? name && isString t.name && t ? verify && isFunction t.verify;
in
lib.fix (self: {

  /*
    `errors type "<context>" value` gives a list of string error messages,
    each prefixed with "<context>: ", for why `value` is not of type `type`

    Only use this if `type.verify value` is false

    Types can override this by specifying their own `type.errors = ctx: value:` attribute

    This is intentionally not tied into `type.verify`,
    in order to keep the successful path as fast as possible with minimal allocations
  */
  errors =
    t:
    t.errors or (ctx: v: [
      "${ctx}: Invalid value; expected ${t.name}, got\n    ${
        lib.generators.toPretty { indent = "    "; } v
      }"
    ]);

  string = {
    name = "string";
    verify = isString;
  };
  str = self.string; # Type alias

  any = {
    name = "any";
    verify = _: true;
  };

  int = {
    name = "int";
    verify = isInt;
  };

  float = {
    name = "float";
    verify = isFloat;
  };

  bool = {
    name = "bool";
    verify = isBool;
  };

  attrs = {
    name = "attrs";
    verify = isAttrs;
  };

  list = {
    name = "list";
    verify = isList;
  };

  attrsOf =
    t:
    assert isTypeDef t;
    let
      inherit (t) verify;
    in
    {
      name = "attrsOf<${t.name}>";
      verify =
        # attrsOf<any> can be optimised to just isAttrs
        if t == self.any then isAttrs else attrs: isAttrs attrs && all verify (attrValues attrs);
    };

  listOf =
    t:
    assert isTypeDef t;
    let
      inherit (t) verify;
    in
    {
      name = "listOf<${t.name}>";
      verify =
        # listOf<any> can be optimised to just isList
        if t == self.any then isList else v: isList v && all verify v;
    };

  union =
    types:
    assert all isTypeDef types;
    let
      # Store a list of functions so we don't have to pay the cost of attrset lookups at runtime.
      funcs = map (t: t.verify) types;
    in
    {
      name = "union<${concatStringsSep "," (map (t: t.name) types)}>";
      verify = v: any (func: func v) funcs;
    };

  record =
    fields:
    assert isAttrs fields && all isTypeDef (attrValues fields);
    let
      # Map attrs directly to the verify function for performance
      fieldVerifiers = mapAttrs (_: t: t.verify) fields;
    in
    {
      name = "record";
      verify = v: isAttrs v && all (k: fieldVerifiers ? ${k} && fieldVerifiers.${k} v.${k}) (attrNames v);
      errors =
        ctx: v:
        if !isAttrs v then
          self.errors self.attrs ctx v
        else
          concatMap (
            k:
            if fieldVerifiers ? ${k} then
              lib.optionals (fieldVerifiers.${k} v.${k}) (self.errors fields.${k} (ctx + ".${k}") v.${k})
            else
              [
                "${ctx}: key '${k}' is unrecognized; expected one of: \n  [${
                  concatMapStringsSep ", " (x: "'${x}'") (attrNames fields)
                }]"
              ]
          ) (attrNames v);
    };

})

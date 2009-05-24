# Operations on attribute sets.

with {
  inherit (builtins) head tail isString;
  inherit (import ./default.nix) fold;
  inherit (import ./strings.nix) concatStringsSep;
};

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs;


  /* Return an attribute from nested attribute sets.  For instance
     ["x" "y"] applied to some set e returns e.x.y, if it exists.  The
     default value is returned otherwise.  */
  attrByPath = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if builtins ? hasAttr && hasAttr attr e
      then attrByPath (tail attrPath) default (getAttr attr e)
      else default;

  /* Backwards compatibility hack: lib.attrByPath used to be called
     lib.getAttr, which was confusing given that there was also a
     builtins.getAttr.  Eventually we'll drop this hack and
     lib.getAttr will just be an alias for builtins.getAttr. */
  getAttr = a: b: if isString a
    then builtins.getAttr a b
    else c: builtins.trace "Deprecated use of lib.getAttr!" (attrByPath a b c);


  getAttrFromPath = attrPath: set:
    let errorMsg = "cannot find attribute `" + concatStringsSep "." attrPath + "'";
    in attrByPath attrPath (abort errorMsg) set;
      

  /* Return the specified attributes from a set.

     Example:
       attrVals ["a" "b" "c"] as
       => [as.a as.b as.c]
  */
  attrVals = nameList: set:
    map (x: getAttr x set) nameList;


  /* Return the values of all attributes in the given set, sorted by
     attribute name.

     Example:
       attrValues {c = 3; a = 1; b = 2;}
       => [1 2 3]
  */
  attrValues = attrs: attrVals (attrNames attrs) attrs;


  /* Collect each attribute named `attr' from a list of attribute
     sets.  Sets that don't contain the named attribute are ignored.

     Example:
       catAttrs "a" [{a = 1;} {b = 0;} {a = 2;}]
       => [1 2]
  */
  catAttrs = attr: l: fold (s: l: if hasAttr attr s then [(getAttr attr s)] ++ l else l) [] l;


  /* Utility function that creates a {name, value} pair as expected by
     builtins.listToAttrs. */
  nameValuePair = name: value: { inherit name value; };

  
  /* Apply a function to each element in an attribute set.  The
     function takes two arguments --- the attribute name and its value
     --- and returns the new value for the attribute.  The result is a
     new attribute set.

     Example:
       mapAttrs (name: value: name + "-" + value)
          {x = "foo"; y = "bar";}
       => {x = "x-foo"; y = "y-bar";}
  */
  mapAttrs = f: set:
    listToAttrs (map (attr: nameValuePair attr (f attr (getAttr attr set))) (attrNames set));
    

  /* Like `mapAttrs', except that it recursively applies itself to
     attribute sets.  Also, the first argument of the argument
     function is a *list* of the names of the containing attributes.

     Type:
       mapAttrsRecursive ::
         ([String] -> a -> b) -> AttrSet -> AttrSet

     Example:
       mapAttrsRecursive (path: value: concatStringsSep "-" (path ++ [value]))
         { n = { a = "A"; m = { b = "B"; c = "C"; }; }; d = "D"; }
       => { n = { a = "n-a-A"; m = { b = "n-m-b-B"; c = "n-m-c-C"; }; }; d = "d-D"; }
  */
  mapAttrsRecursive = mapAttrsRecursiveCond (as: true);

  
  /* Like `mapAttrsRecursive', but it takes an additional predicate
     function that tells it whether to recursive into an attribute
     set.  If it returns false, `mapAttrsRecursiveCond' does not
     recurse, but does apply the map function.  It is returns true, it
     does recurse, and does not apply the map function.

     Type:
       mapAttrsRecursiveCond ::
         (AttrSet -> Bool) -> ([String] -> a -> b) -> AttrSet -> AttrSet

     Example:
       # To prevent recursing into derivations (which are attribute
       # sets with the attribute "type" equal to "derivation"):
       mapAttrsRecursiveCond
         (as: !(as ? "type" && as.type == "derivation"))
         (x: ... do something ...)
         attrs
     */
  mapAttrsRecursiveCond = cond: f: set:
    let
      recurse = path: set:
        let
          g =
            name: value:
            if isAttrs value && cond value
              then recurse (path ++ [name]) value
              else f (path ++ [name]) value;
        in mapAttrs g set;
    in recurse [] set;


  /* Check whether the argument is a derivation. */
  isDerivation = x: isAttrs x && x ? type && x.type == "derivation";

}

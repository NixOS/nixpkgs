# Operations on attribute sets.

with {
  inherit (builtins) head tail;
  inherit (import ./default.nix) fold;
  inherit (import ./strings.nix) concatStringsSep;
};

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs;


  /* Return an attribute from nested attribute sets.  For instance
     ["x" "y"] applied to some set e returns e.x.y, if it exists.  The
     default value is returned otherwise.  !!! there is also
     builtins.getAttr (is there a better name for this function?)
  */
  getAttr = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if builtins ? hasAttr && hasAttr attr e
      then getAttr (tail attrPath) default (builtins.getAttr attr e)
      else default;


  getAttrFromPath = attrPath: set:
    let errorMsg = "cannot find attribute `" + concatStringsSep "." attrPath + "'";
    in getAttr attrPath (abort errorMsg) set;
      

  /* Return the specified attributes from a set.

     Example:
       attrVals ["a" "b" "c"] as
       => [as.a as.b as.c]
  */
  attrVals = nameList: set:
    map (x: builtins.getAttr x set) nameList;


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
  catAttrs = attr: l: fold (s: l: if hasAttr attr s then [(builtins.getAttr attr s)] ++ l else l) [] l;


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
    listToAttrs (map (attr: nameValuePair attr (f attr (builtins.getAttr attr set))) (attrNames set));
    

  /* Like `mapAttrs', except that it recursively applies itself to
     values that attribute sets.  Also, the first argument is a *list*
     of the names of the containing attributes.

     Example:
       mapAttrsRecursive (path: value: concatStringsSep "-" (path ++ [value]))
         { n = { a = "A"; m = { b = "B"; c = "C"; }; }; d = "D"; }
       => { n = { a = "n-a-A"; m = { b = "n-m-b-B"; c = "n-m-c-C"; }; }; d = "d-D"; }
  */
  mapAttrsRecursive =
    let
      recurse = path: f: set:
        let
          g =
            name: value:
            if isAttrs value
              then recurse (path ++ [name]) f value
              else f (path ++ [name]) value;
        in mapAttrs g set;
    in recurse [];
  
}

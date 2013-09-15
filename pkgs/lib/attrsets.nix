# Operations on attribute sets.

with {
  inherit (builtins) head tail isString;
  inherit (import ./trivial.nix) or;
  inherit (import ./default.nix) fold;
  inherit (import ./strings.nix) concatStringsSep;
  inherit (import ./lists.nix) concatMap concatLists all deepSeqList;
  inherit (import ./misc.nix) maybeAttr;
};

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs getAttr;


  /* Return an attribute from nested attribute sets.  For instance
     ["x" "y"] applied to some set e returns e.x.y, if it exists.  The
     default value is returned otherwise. */
  attrByPath = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if builtins ? hasAttr && hasAttr attr e
      then attrByPath (tail attrPath) default (getAttr attr e)
      else default;


  /* Return nested attribute set in which an attribute is set.  For instance
     ["x" "y"] applied with some value v returns `x.y = v;' */
  setAttrByPath = attrPath: value:
    if attrPath == [] then value
    else listToAttrs [(
      nameValuePair (head attrPath) (setAttrByPath (tail attrPath) value)
    )];


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
  catAttrs = attr: l: concatLists (map (s: if hasAttr attr s then [(getAttr attr s)] else []) l);


  /* Filter an attribute set by removing all attributes for which the
     given predicate return false.

     Example:
       filterAttrs (n: v: n == "foo") { foo = 1; bar = 2; }
       => { foo = 1; }
  */
  filterAttrs = pred: set:
    listToAttrs (fold (n: ys: let v = getAttr n set; in if pred n v then [(nameValuePair n v)] ++ ys else ys) [] (attrNames set));


  /* foldAttrs: apply fold functions to values grouped by key. Eg accumulate values as list:
     foldAttrs (n: a: [n] ++ a) [] [{ a = 2; } { a = 3; }]
     => { a = [ 2 3 ]; }
  */
  foldAttrs = op: nul: list_of_attrs:
    fold (n: a:
        fold (name: o:
          o // (listToAttrs [{inherit name; value = op (getAttr name n) (maybeAttr name nul a); }])
        ) a (attrNames n)
    ) {} list_of_attrs;


  /* Recursively collect sets that verify a given predicate named `pred'
     from the set `attrs'.  The recursion is stopped when the predicate is
     verified.

     Type:
       collect ::
         (AttrSet -> Bool) -> AttrSet -> AttrSet

     Example:
       collect builtins.isList { a = { b = ["b"]; }; c = [1]; }
       => [["b"] [1]]

       collect (x: x ? outPath)
          { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }
       => [{ outPath = "a/"; } { outPath = "b/"; }]
  */
  collect = pred: attrs:
    if pred attrs then
      [ attrs ]
    else if builtins.isAttrs attrs then
      concatMap (collect pred) (attrValues attrs)
    else
      [];


  /* Utility function that creates a {name, value} pair as expected by
     builtins.listToAttrs. */
  nameValuePair = name: value: { inherit name value; };


  /* Apply a function to each element in an attribute set.  The
     function takes two arguments --- the attribute name and its value
     --- and returns the new value for the attribute.  The result is a
     new attribute set.

     Example:
       mapAttrs (name: value: name + "-" + value)
          { x = "foo"; y = "bar"; }
       => { x = "x-foo"; y = "y-bar"; }
  */
  mapAttrs = f: set:
    listToAttrs (map (attr: nameValuePair attr (f attr (getAttr attr set))) (attrNames set));


  /* Like `mapAttrs', but allows the name of each attribute to be
     changed in addition to the value.  The applied function should
     return both the new name and value as a `nameValuePair'.

     Example:
       mapAttrs' (name: value: nameValuePair ("foo_" + name) ("bar-" + value))
          { x = "a"; y = "b"; }
       => { foo_x = "bar-a"; foo_y = "bar-b"; }
  */
  mapAttrs' = f: set:
    listToAttrs (map (attr: f attr (getAttr attr set)) (attrNames set));


  /* Call a function for each attribute in the given set and return
     the result in a list.

     Example:
       mapAttrsToList (name: value: name + value)
          { x = "a"; y = "b"; }
       => [ "xa" "yb" ]
  */
  mapAttrsToList = f: attrs:
    map (name: f name (getAttr name attrs)) (attrNames attrs);


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


  /* Generate an attribute set by mapping a function over a list of
     attribute names.

     Example:
       genAttrs [ "foo" "bar" ] (name: "x_" + name)
       => { foo = "x_foo"; bar = "x_bar"; }
  */
  genAttrs = names: f:
    listToAttrs (map (n: nameValuePair n (f n)) names);


  /* Check whether the argument is a derivation. */
  isDerivation = x: isAttrs x && x ? type && x.type == "derivation";


  /* If the Boolean `cond' is true, return the attribute set `as',
     otherwise an empty attribute set. */
  optionalAttrs = cond: as: if cond then as else {};


  /* Merge sets of attributes and use the function f to merge attributes
     values. */
  zipAttrsWithNames = names: f: sets:
    listToAttrs (map (name: {
      inherit name;
      value = f name (catAttrs name sets);
    }) names);

  # implentation note: Common names  appear multiple times in the list of
  # names, hopefully this does not affect the system because the maximal
  # laziness avoid computing twice the same expression and listToAttrs does
  # not care about duplicated attribute names.
  zipAttrsWith = f: sets: zipWithNames (concatMap attrNames sets) f sets;

  zipAttrs = zipAttrsWith (name: values: values);

  /* backward compatibility */
  zipWithNames = zipAttrsWithNames;
  zip = builtins.trace "lib.zip is deprecated, use lib.zipAttrsWith instead" zipAttrsWith;


  /* Does the same as the update operator '//' except that attributes are
     merged until the given pedicate is verified.  The predicate should
     accept 3 arguments which are the path to reach the attribute, a part of
     the first attribute set and a part of the second attribute set.  When
     the predicate is verified, the value of the first attribute set is
     replaced by the value of the second attribute set.

     Example:
       recursiveUpdateUntil (path: l: r: path == ["foo"]) {
         # first attribute set
         foo.bar = 1;
         foo.baz = 2;
         bar = 3;
       } {
         #second attribute set
         foo.bar = 1;
         foo.quz = 2;
         baz = 4;
       }

       returns: {
         foo.bar = 1; # 'foo.*' from the second set
         foo.quz = 2; #
         bar = 3;     # 'bar' from the first set
         baz = 4;     # 'baz' from the second set
       }

     */
  recursiveUpdateUntil = pred: lhs: rhs:
    let f = attrPath:
      zipAttrsWith (n: values:
        if tail values == []
        || pred attrPath (head (tail values)) (head values) then
          head values
        else
          f (attrPath ++ [n]) values
      );
    in f [] [rhs lhs];

  /* A recursive variant of the update operator ‘//’.  The recusion
     stops when one of the attribute values is not an attribute set,
     in which case the right hand side value takes precedence over the
     left hand side value.

     Example:
       recursiveUpdate {
         boot.loader.grub.enable = true;
         boot.loader.grub.device = "/dev/hda";
       } {
         boot.loader.grub.device = "";
       }

       returns: {
         boot.loader.grub.enable = true;
         boot.loader.grub.device = "";
       }

     */
  recursiveUpdate = lhs: rhs:
    recursiveUpdateUntil (path: lhs: rhs:
      !(isAttrs lhs && isAttrs rhs)
    ) lhs rhs;

  matchAttrs = pattern: attrs:
    fold or false (attrValues (zipAttrsWithNames (attrNames pattern) (n: values:
      let pat = head values; val = head (tail values); in
      if length values == 1 then false
      else if isAttrs pat then isAttrs val && matchAttrs head values
      else pat == val
    ) [pattern attrs]));

  # override only the attributes that are already present in the old set
  # useful for deep-overriding
  overrideExisting = old: new:
    old // listToAttrs (map (attr: nameValuePair attr (attrByPath [attr] (getAttr attr old) new)) (attrNames old));

  deepSeqAttrs = x: y: deepSeqList (attrValues x) y;
}

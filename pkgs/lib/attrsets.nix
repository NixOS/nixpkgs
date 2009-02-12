# Operations on attribute sets.

with { inherit (builtins) head tail; };

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs;


  # Return an attribute from nested attribute sets.  For instance ["x"
  # "y"] applied to some set e returns e.x.y, if it exists.  The
  # default value is returned otherwise.  !!! there is also
  # builtins.getAttr (is there a better name for this function?)
  getAttr = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if builtins ? hasAttr && hasAttr attr e
      then getAttr (tail attrPath) default (builtins.getAttr attr e)
      else default;


}
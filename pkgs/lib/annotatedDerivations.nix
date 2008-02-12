{ lib } : with lib; with builtins; rec {
  /*
  # traversal proposal (very unstable now )
  # goal: create tags easily (and install source files along without recompiling)

  rec {
    # encouraged: using it you can filter based on names later on? Do we ned it?
    name = 

    # required: the annotated derivation (this attr is used to identify a
    # annotated derivation)
    aDeriv =

    # required: extra list of annotated dependencies, so we can traverse the tree
    aDeps = <annotated deps>

    # your annotation derivations 
  };
  */

  isAnnotated = a : (a ? aDeriv); # this function serves documentation purposes 

  delAnnotation = a :
    if ((__isAttrs a) && (isAnnotated a)) then  a.aDeriv
    else a; # most probalby a derivation without annotations.

  # returns buildInputs and propagatedBuildInputs from given set after removing annotations
  delAnnotationsFromInputs = attrs :
    subsetmap (map delAnnotation) attrs [ "buildInputs" "propagatedBuildInputs" ];

  /* so an annotated drivation function might look like this
  args: with args;
    let aDeps = filterDeps args;
        deps = delAnnotation aDeps;
    in rec {
      name = "my-package-0.2";
      inherit aDeps;

      aDeriv = stdenv.mkDerivation {
        inherit name;
        buildInputs = deps;
      };
    };

  */

  filterAnnotated = lib.filter isAnnotated;

  # stops when depthCounter = 0 
  traverseByDepthCounter = depthCounter : aAttrs :
    if (depthCounter == 0) then []
    else [ aAttrs ] ++ map (traverseByDepthCounter (__sub depthCounter 1) ) (filterAnnotated aAttrs.aDeps);

  # get all deps recursively
  uniqAnnotatedDeps = aAttrs : uniqList { inputList = traverseByDepthCounter 10 aAttrs; };
}

let
  pkgs = import ./. {} ;
  inherit (pkgs) lib;
  inherit (lib) types;
  inherit (pkgs.lib.types) annotated;
in
  {
    test_has_annotation_trivial_type = let
      type = annotated { test = 1;} (types.str);
    in
    {
      expr = type.functor.payload.annotation;
      expected = { test = 1; };
    };
    test_merge_annotation_trivial_type = let
      typeA = annotated { test = 1;} (types.str);
      typeB = annotated { test = 1;} (types.str);
      mergedType = types.defaultTypeMerge "" typeA.functor typeB.functor;
    in
    {
      expr = mergedType.functor.payload.annotation;
      expected = { test = 1; };
    };
    test_has_annotation_composed_type = let
      type = annotated { test = 1;} (types.attrsOf types.int);
    in
    {
      expr = type.functor.payload.annotation;
      expected = { test = 1; };
    };
    test_merge_annotation_composed_type = let
      typeA = annotated { test = 1;} (types.attrsOf types.int);
      typeB = annotated { test = 1;} (types.attrsOf types.int);
      mergedType = types.defaultTypeMerge "" typeA.functor typeB.functor;
    in
    {
      expr = mergedType.functor.payload.annotation;
      expected = { test = 1; };
    };
    test_merge_annotation_composed_type_2 = let
      typeA = annotated { test = 1;} (types.listOf types.int);
      typeB = annotated { test = 1;} (types.listOf types.int);
      mergedType = types.defaultTypeMerge "" typeA.functor typeB.functor;
    in
    {
      expr = mergedType.functor.payload.annotation;
      expected = { test = 1; };
    };
    test_merge_annotation_composed_type_3 = let
      typeA = annotated { test = 1;} (types.enum ["foo" "bar"]);
      typeB = annotated { test = 1;} (types.enum ["foo" "bar"]);
      mergedType = types.defaultTypeMerge "" typeA.functor typeB.functor;
    in
    {
      expr = mergedType.functor.payload.annotation;
      expected = { test = 1; };
    };
  }
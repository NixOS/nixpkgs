let inherit (builtins) add; in
with import ./default.nix;

runTests {

  testId = {
    expr = id 1;
    expected = 1;
  };
  
  testConst = {
    expr = const 2 3;
    expected = 2;
  };
  
  testOr = {
    expr = or true false;
    expected = true;
  };
  
  testAnd = {
    expr = and true false;
    expected = false;
  };
  
  testFix = {
    expr = fix (x: {a = if x ? a then "a" else "b";});
    expected = {a = "a";};
  };

  testConcatMapStrings = {
    expr = concatMapStrings (x: x + ";") ["a" "b" "c"];
    expected = "a;b;c;";
  };

  testConcatStringsSep = {
    expr = concatStringsSep "," ["a" "b" "c"];
    expected = "a,b,c";
  };

  testFilter = {
    expr = filter (x: x != "a") ["a" "b" "c" "a"];
    expected = ["b" "c"];
  };

  testFold = {
    expr = fold (builtins.add) 0 (range 0 100);
    expected = 5050;
  };

  testEqStrict = {
    expr = all id [
      (eqStrict 2 2)
      (!eqStrict 3 2)
      (eqStrict [2 1] [2 1])
      (!eqStrict [1 3] [1 2])
      (eqStrict {a = 7; b = 20;} {b= 20; a = 7;})
      (eqStrict [{a = 7; b = 20;}] [{b= 20; a = 7;}])
      (eqStrict {a = [7 8]; b = 20;} {b= 20; a = [7 8];})
    ];
    expected = true;
  };

  testOverridableDelayableArgsTest = {
    expr = 
      let res1 = defaultOverridableDelayableArgs id {};
          res2 = defaultOverridableDelayableArgs id { a = 7; };
          res3 = let x = defaultOverridableDelayableArgs id { a = 7; };
                 in (x.merge) { b = 10; };
          res4 = let x = defaultOverridableDelayableArgs id { a = 7; };
                in (x.merge) ( x: { b = 10; });
          res5 = let x = defaultOverridableDelayableArgs id { a = 7; };
                in (x.merge) ( x: { a = add x.a 3; });
          res6 = let x = defaultOverridableDelayableArgs id { a = 7; mergeAttrBy = { a = add; }; };
                     y = x.merge {};
                in (y.merge) { a = 10; };

          resRem7 = res6.replace (a : removeAttrs a ["a"]);

          resReplace6 = let x = defaultOverridableDelayableArgs id { a = 7; mergeAttrBy = { a = add; }; };
                            x2 = x.merge { a = 20; }; # now we have 27
                        in (x2.replace) { a = 10; }; # and override the value by 10

          # fixed tests (delayed args): (when using them add some comments, please)
          resFixed1 = 
                let x = defaultOverridableDelayableArgs id ( x : { a = 7; c = x.fixed.b; });
                    y = x.merge (x : { name = "name-${builtins.toString x.fixed.c}"; });
                in (y.merge) { b = 10; };
          strip = attrs : removeAttrs attrs ["merge" "replace"];
      in all id
        [ (eqStrict (strip res1) { })
          (eqStrict (strip res2) { a = 7; })
          (eqStrict (strip res3) { a = 7; b = 10; })
          (eqStrict (strip res4) { a = 7; b = 10; })
          (eqStrict (strip res5) { a = 10; })
          (eqStrict (strip res6) { a = 17; })
          (eqStrict (strip resRem7) {})
          (eqStrict (strip resFixed1) { a = 7; b = 10; c =10; name = "name-10"; })
        ];
    expected = true;
  };
  
}

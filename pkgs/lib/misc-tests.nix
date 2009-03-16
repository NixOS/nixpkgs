let lib = import ./default.nix;

    eqStrictTest =
      let inherit(lib) eqStrict; in
      assert eqStrict 2 2;
      assert !(eqStrict 3 2);
      assert eqStrict [2 1] [2 1];
      assert !(eqStrict [1 3] [1 2]);
      assert eqStrict {a = 7; b = 20;} {b= 20; a = 7;};
      assert eqStrict [{a = 7; b = 20;}] [{b= 20; a = 7;}];
      assert eqStrict {a = [7 8]; b = 20;} {b= 20; a = [7 8];};
      "ok";

    overridableDelayableArgsTest =
      let inherit (lib) defaultOverridableDelayableArgs;
          res1 = defaultOverridableDelayableArgs lib.id {};
          res2 = defaultOverridableDelayableArgs lib.id { a = 7; };
          res3 = let x = defaultOverridableDelayableArgs lib.id { a = 7; };
                 in (x.merge) { b = 10; };
          res4 = let x = defaultOverridableDelayableArgs lib.id { a = 7; };
                in (x.merge) ( x: { b = 10; });
          res5 = let x = defaultOverridableDelayableArgs lib.id { a = 7; };
                in (x.merge) ( x: { a = __add x.a 3; });
          res6 = let x = defaultOverridableDelayableArgs lib.id { a = 7; mergeAttrBy = { a = __add; }; };
                     y = x.merge {};
                in (y.merge) { a = 10; };

          resRem7 = res6.replace (a : removeAttrs a ["a"]);

          resReplace6 = let x = defaultOverridableDelayableArgs lib.id { a = 7; mergeAttrBy = { a = __add; }; };
                            x2 = x.merge { a = 20; }; # now we have 27
                        in (x2.replace) { a = 10; }; # and override the value by 10

          # fixed tests (delayed args): (when using them add some comments, please)
          resFixed1 = 
                let x = defaultOverridableDelayableArgs lib.id ( x : { a = 7; c = x.fixed.b; });
                    y = x.merge (x : { name = "name-${builtins.toString x.fixed.c}"; });
                in (y.merge) { b = 10; };
          strip = attrs : removeAttrs attrs ["merge" "replace"];

          in 
             assert lib.eqStrict (strip res1) { };
             assert lib.eqStrict (strip res2) { a = 7; };
             assert lib.eqStrict (strip res3) { a = 7; b = 10; };
             assert lib.eqStrict (strip res4) { a = 7; b = 10; };
             assert lib.eqStrict (strip res5) { a = 10; };
             assert lib.eqStrict (strip res6) { a = 17; };
             assert lib.eqStrict (strip resRem7) {};
             assert lib.eqStrict (strip resFixed1) { a = 7; b = 10; c =10; name = "name-10"; };
             "ok";


in [ eqStrictTest overridableDelayableArgsTest ]

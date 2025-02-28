{
  lib,
  makeSetupHook',
  testers,
}:
let
  exampleHook = makeSetupHook' {
    name = "exampleHook";
    script = ./example-hook.bash;
  };

  mkExampleArrayTest =
    name:
    testers.testEqualArrayOrMap {
      inherit name;
      valuesArray = [
        1
        2
        3
        4
        5
      ];
      expectedArray = [
        2
        3
        4
        5
        6
      ];
      script = null; # The hook uses scriptHooks, but the script argument must be present.
    };
in
lib.recurseIntoAttrs {
  # Test that the hook executes successfully when included once.
  testHookRunWhenIncludedOnce =
    (mkExampleArrayTest "testHookRunWhenIncludedOnce").overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [
          exampleHook
        ];
      });

  # Test that the hook executes successfully even when included twice.
  testHookRunWhenIncludedTwice =
    (mkExampleArrayTest "testHookRunWhenIncludedTwice").overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [
          exampleHook
          exampleHook
        ];
      });

  # Test that the hook doesn't get sourced twice when included twice by verifying `scriptHooks` is contains only one
  # copy of the hooks our setup hook adds when sourced.
  testScriptHooksWhenIncludedTwice =
    ((mkExampleArrayTest "testScriptHooksWhenIncludedTwice").override {
      script = ''
        nixLog "checking that scriptHooks contains only two entires..."
        if ((''${#scriptHooks[@]} != 2)); then
          nixErrorLog "scriptHooks contains ''${#scriptHooks[@]} entries, but it should contain only 2"
          exit 1
        fi

        nixLog "checking that scriptHooks contains the expected entries..."
        if [[ ''${scriptHooks[0]} != "copyValuesArrayToActualArray" ]]; then
          nixErrorLog "scriptHooks[0] contains ''${scriptHooks[0]}', but it should contain 'copyValuesArrayToActualArray'"
          exit 1
        fi
        if [[ ''${scriptHooks[1]} != "addOneToActualArrayMembers" ]]; then
          nixErrorLog "scriptHooks[1] contains ''${scriptHooks[1]}', but it should contain 'addOneToActualArrayMembers'"
          exit 1
        fi
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [
          exampleHook
          exampleHook
        ];
      });
}

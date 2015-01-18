{ config, lib, ... }:

with lib;

let
  assertionOptions = {
    assertion = mkOption {
      default = true;
      description = "What to assert.";
      type = types.bool;
    };

    message = mkOption {
      default = "";
      description = "Message to show on failed assertion.";
      type = types.str;
    };
  };

in {
  options = {

    assertions = mkOption {
      type = types.listOf types.optionSet;
      internal = true;
      default = [];
      options = [ assertionOptions ];
      example = [ { assertion = false; message = "you can't enable this for that reason"; } ];
      apply = assertions: {
        outPath = assertions;
        check = res: let
          failed = map (x: x.message) (filter (x: !x.assertion) assertions);
        in if [] == failed then res else
          throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failed)}";
      };
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = mkOption {
      internal = true;
      default = [];
      type = types.listOf types.string;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      apply = warnings: {
        outPath = warnings;
        print = res: fold (w: x: builtins.trace "^[[1;31mwarning: ${w}^[[0m" x) res warnings;
      };
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };

  };
}

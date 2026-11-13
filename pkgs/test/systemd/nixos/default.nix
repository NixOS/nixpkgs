{
  pkgs,
  lib,
  ...
}:

let
  # Evaluate a unit section with a single setting and report whether the
  # configuration still evaluates. Resource-control values that systemd itself
  # cannot parse are reported and then ignored by systemd, leaving the unit with
  # no limit, so they must be refused here instead.
  settingEvaluates =
    unitType: section: setting: value:
    let
      nixos = pkgs.nixos {
        system.stateVersion = lib.trivial.release;
        systemd.${unitType}.systemd-test-nixos.${section}.${setting} = value;
      };
    in
    (builtins.tryEval nixos.config.systemd.${unitType}.systemd-test-nixos.${section}.${setting})
    .success;

  serviceSetting = settingEvaluates "services" "serviceConfig";

  # systemd.mounts is a list of units rather than an attribute set.
  mountSettingEvaluates =
    setting: value:
    let
      nixos = pkgs.nixos {
        system.stateVersion = lib.trivial.release;
        systemd.mounts = [
          {
            what = "/dev/null";
            where = "/mnt/systemd-test-nixos";
            mountConfig.${setting} = value;
          }
        ];
      };
    in
    (builtins.tryEval (lib.head nixos.config.systemd.mounts).mountConfig.${setting}).success;

  failures = lib.runTests {
    # Merging two non-list definitions must still result in an error
    # about a conflicting definition.
    test-unitOption-merging-non-lists-conflict =
      let
        nixos = pkgs.nixos {
          system.stateVersion = lib.trivial.release;
          systemd.services.systemd-test-nixos = {
            serviceConfig = lib.mkMerge [
              { StateDirectory = "foo"; }
              { StateDirectory = "bar"; }
            ];
          };
        };
      in
      {
        expr =
          (builtins.tryEval (nixos.config.systemd.services.systemd-test-nixos.serviceConfig.StateDirectory))
          .success;
        expected = false;
      };

    # Merging must lift non-list definitions to a list
    # if at least one of them is a list.
    test-unitOption-merging-list-non-list-append =
      let
        nixos = pkgs.nixos {
          system.stateVersion = lib.trivial.release;
          systemd.services.systemd-test-nixos = {
            serviceConfig = lib.mkMerge [
              { StateDirectory = "foo"; }
              { StateDirectory = [ "bar" ]; }
            ];
          };
        };
      in
      {
        expr = nixos.config.systemd.services.systemd-test-nixos.serviceConfig.StateDirectory;
        expected = [
          "foo"
          "bar"
        ];
      };

    # systemd parses sizes with parse_size(): a number and at most one suffix,
    # so "13GB" is not a size. Percentages are capped at 100% here, and an
    # empty assignment unsets the setting.
    test-resource-control-memory = {
      expr = lib.genAttrs [
        "13G"
        "1.5G"
        "20%"
        "100%"
        "infinity"
        ""
        "13GB"
        "13g"
        "150%"
      ] (serviceSetting "MemoryMax");
      expected = {
        "13G" = true;
        "1.5G" = true;
        "20%" = true;
        "100%" = true;
        "infinity" = true;
        "" = true;
        "13GB" = false;
        "13g" = false;
        "150%" = false;
      };
    };

    # CPUQuota is the one setting parsed with the unbounded percentage parser,
    # which still only accepts two decimal places.
    test-resource-control-cpu-quota = {
      expr = lib.genAttrs [
        "100%"
        "475%"
        "12.55%"
        "475"
        "12.555%"
        "infinity"
      ] (serviceSetting "CPUQuota");
      expected = {
        "100%" = true;
        "475%" = true;
        "12.55%" = true;
        "475" = false;
        "12.555%" = false;
        "infinity" = false;
      };
    };

    test-resource-control-tasks-max = {
      expr = lib.genAttrs [
        "4096"
        "80%"
        "infinity"
        "4096M"
      ] (serviceSetting "TasksMax");
      expected = {
        "4096" = true;
        "80%" = true;
        "infinity" = true;
        "4096M" = false;
      };
    };

    # The byte-based resource limits also take a soft:hard pair.
    test-resource-control-rlimit = {
      expr = lib.genAttrs [
        "64M"
        "infinity"
        "64M:128M"
        "64M:infinity"
        "64MB"
        "64M:"
      ] (serviceSetting "LimitMEMLOCK");
      expected = {
        "64M" = true;
        "infinity" = true;
        "64M:128M" = true;
        "64M:infinity" = true;
        "64MB" = false;
        "64M:" = false;
      };
    };

    # Resource control applies to these unit types too.
    test-resource-control-other-unit-types = {
      expr = {
        slice = settingEvaluates "slices" "sliceConfig" "MemoryMax" "2GB";
        socket = settingEvaluates "sockets" "socketConfig" "MemoryMax" "1GB";
        mount = mountSettingEvaluates "MemoryMax" "1GB";
      };
      expected = {
        slice = false;
        socket = false;
        mount = false;
      };
    };
  };
in

lib.debug.throwTestFailures {
  inherit failures;
  description = "systemd unit tests";
}

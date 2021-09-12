{ config, nixpkgs }:

let
  lib = import (nixpkgs + "/lib");
  module = import (nixpkgs + "/nixos/modules/virtualisation/containers-next.nix");
  neededOptions = (module {
    pkgs = null;
    config = null;
    lib = import (nixpkgs + "/lib");
  }).options.nixos.containers;

  dummy = (import (nixpkgs + "/lib")).evalModules {
    modules = [
      (nixpkgs + "/nixos/modules/misc/assertions.nix")
      { options = builtins.removeAttrs neededOptions [ "rendered" ]; }
      {
        instances.imperative = lib.mkMerge [
          config
          {
            config.boot.isContainer = true;
            nixpkgs = lib.mkDefault nixpkgs;
            # FIXME get rid of this hack!
            # On a test-system I experienced that this service was hanging for no reason.
            # After a config-activation in ExecReload which affected larger parts of the OS in the
            # container, `nixops` waited until the timeout was reached. However, the networkd
            # was routable and the `host0` interface reached the state `configured`. Hence I'd guess
            # that this is a networkd bug that requires investigation. Until then, I'll leave
            # this as-is.
            config.systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = lib.mkForce [
              ""
              "/run/current-system/sw/bin/true"
            ];
            config.networking = {
              useHostResolvConf = false;
              useDHCP = false;
              useNetworkd = true;
            };
            config.systemd.network.networks."20-host0" = {
              matchConfig = {
                Virtualization = "container";
                Name = "host0";
              };
              linkConfig.RequiredForOnline = "no";
              dhcpConfig.UseTimezone = "yes";
              networkConfig = {
                DHCP = "yes";
                LLDP = "yes";
                EmitLLDP = "customer-bridge";
                LinkLocalAddressing = lib.mkDefault "ipv6";
              };
            };
          }
        ];
      }
      ({ config, ... }: {
        assertions = [
          { assertion = config.instances.imperative.sharedNix;
            message = "Experimental `sharedNix'-feature isn't supported for imperative containers!";
          }
        ];
      })
    ];
  };

  nixpkgs' = dummy.config.instances.imperative.nixpkgs;
  container = import (nixpkgs' + "/nixos") {
    configuration.imports = dummy.config.instances.imperative.config;
  };
  pkgs = import nixpkgs' { };

  assertions = with lib;
    let
      failed =  filter
        (x: !x.assertion)
        dummy.config.assertions;
    in
      if failed == [] then
        null
      else throw ''
        Failed assertions:

        ${concatMapStringsSep "\n" (x: "* ${x.message}") failed}
      '';
in
  builtins.deepSeq assertions (pkgs.buildEnv {
    name = "final";
    paths = [
      container.system
      (pkgs.writeTextDir "data"
        (builtins.toJSON (builtins.removeAttrs (dummy.config.instances.imperative) [ "config" ])))
    ];
  })

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

  # FIXME deepSeq
  assertions = x: with lib;
    let
      failed =  filter
        (x: !x.assertion)
        dummy.config.assertions;
    in
      if failed == [] then
        x
      else throw ''
        Failed assertions:

        ${concatMapStringsSep "\n" (x: "* ${x.message}") failed}
      '';
in
  assertions (pkgs.buildEnv {
    name = "final";
    paths = [
      container.system
      (pkgs.writeTextDir "data"
        (builtins.toJSON (builtins.removeAttrs (dummy.config.instances.imperative) [ "config" ])))
    ];
  })

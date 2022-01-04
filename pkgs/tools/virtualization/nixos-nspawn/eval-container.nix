{ config, nixpkgs }:

let
  lib = import (nixpkgs + "/lib");
  module = import (nixpkgs + "/nixos/modules/virtualisation/containers-next");
  neededOptions = (module {
    pkgs = null;
    config = null;
    lib = import (nixpkgs + "/lib");
  }).options.nixos.containers;

  dummy = (import (nixpkgs + "/lib")).evalModules {
    modules = [
      (nixpkgs + "/nixos/modules/misc/assertions.nix")
      { options = (builtins.removeAttrs neededOptions [ "rendered" ]); }
      {
        instances.imperative = lib.mkMerge [
          config
          {
            nixpkgs = lib.mkDefault nixpkgs;
            activation.strategy = lib.mkDefault "restart";
          }
        ];
      }
      ({ config, ... }: {
        instances.imperative.system-config.imports = [
          (import (nixpkgs + "/nixos/modules/virtualisation/containers-next/container-profile.nix"))
          {
            systemd.network = {
              networks."20-host0".address =
                (if config.instances.imperative.network != null
                  then config.instances.imperative.network.v6.static.containerPool
                    ++ config.instances.imperative.network.v4.static.containerPool
                  else []);
            };
          }
        ];
      })
      ({ config, ... }: {
        assertions = [
          { assertion = config.instances.imperative.sharedNix;
            message = "Experimental `sharedNix'-feature isn't supported for imperative containers!";
          }
          { assertion = config.instances.imperative.activation.strategy != "dynamic";
            message = "`dynamic` is currently not supported!";
          }
        ];
      })
    ];
  };

  nixpkgs' = dummy.config.instances.imperative.nixpkgs;
  container = import (nixpkgs' + "/nixos") {
    configuration.imports = dummy.config.instances.imperative.system-config;
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
        (builtins.toJSON (builtins.removeAttrs (dummy.config.instances.imperative) [ "system-config" ])))
    ];
  })

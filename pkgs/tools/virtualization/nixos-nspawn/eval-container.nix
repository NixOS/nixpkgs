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
      { options = builtins.removeAttrs neededOptions [ "rendered" ]; }
      {
        instances.imperative = lib.mkMerge [
          config
          { nixpkgs = lib.mkDefault nixpkgs; }
        ];
      }
      {
        instances.imperative.config.imports = [
          (nixpkgs + "/nixos/modules/virtualisation/containers-next/container-profile.nix")
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

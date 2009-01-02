# generate the script used to activate the configuration.
{pkgs, config, ...}:

let
  inherit (pkgs.stringsWithDeps) textClosureOverridable;
  inherit (pkgs.lib) mkOption mergeTypedOption mergeAttrs mapRecordFlatten id;

  textClosure = steps:
    textClosureOverridable steps
    (["#!/bin/sh"] ++ (mapRecordFlatten (a: v: v) steps));

  aggregateScripts = name: steps:
    pkgs.writeScript name (textClosure steps);
in

{
  system = {
    activationScripts = mkOption {
      default = [];
      example = {
        stdio = {
          text = "
            # Needed by some programs.
            ln -sfn /proc/self/fd /dev/fd
            ln -sfn /proc/self/fd/0 /dev/stdin
            ln -sfn /proc/self/fd/1 /dev/stdout
            ln -sfn /proc/self/fd/2 /dev/stderr
          ";
          deps = [];
        };
      };
      description = ''
        Activate the new configuration (i.e., update /etc, make accounts,
        and so on).
      '';
      merge = mergeTypedOption "script" builtins.isAttrs mergeAttrs;
      apply = lib: {
        inherit lib; # used to fetch dependencies.
        script = aggregateScripts "activationScript" lib;
      };
    };
  };
}

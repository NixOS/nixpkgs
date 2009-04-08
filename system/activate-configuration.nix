# generate the script used to activate the configuration.
{pkgs, config, ...}:

let
  inherit (pkgs.stringsWithDeps) textClosureOverridable noDepEntry;
  inherit (pkgs.lib) mkOption mergeTypedOption mergeAttrs mapRecordFlatten
    mapAttrs addErrorContext fold;

  textClosure = steps:
    textClosureOverridable steps (
       [(noDepEntry "#!/bin/sh")]
    ++ (mapRecordFlatten (a: v: v) steps)
    );

  aggregateScripts = name: steps:
    pkgs.writeScript name (textClosure steps);

  addAttributeName = mapAttrs (a: v: {
      text = ''
        #### ${a} begin
        ${v.text}
        #### ${a} end
      '';
      inherit (v) deps;
    });
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
      merge = mergeTypedOption "script" builtins.isAttrs (fold mergeAttrs {});
      apply = set:
        let lib = addAttributeName set; in {
        inherit lib; # used to fetch dependencies.
        script = aggregateScripts "activationScript" lib;
      };
    };
  };
}

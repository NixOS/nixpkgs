# The strange application order is so that this can be a .lib function
# (with a self.callPackage inside and partially applied over defaultOpts)
defaultOpts: { trace, config, pkgs }: { args ? defaultOpts.args, debug ? defaultOpts.debug }:
    let
      inherit (pkgs) lib;
      inherit (trace "debug args:" (defaultOpts.debug // debug)) enable suspend port;
      inherit (trace "args:" (defaultOpts.args // args)) name class maxMemory vmArgs extraArgs enableUserShellArgs;
    in
    let
      opt = pkgs.lib.optionalString;
      nonEmpty = l: builtins.length l != 0;
      nonEmptyS = s: s != "";
      withArgs = cmd: args: cmd + (lib.concatMapStrings (s: " ${s}") args);
      e = lib.escapeShellArg;
    in
    let
      debugPortEnv = "DEBUG_PORT=${e port}"; # TODO update to full address with ghidra update
      envVars = builtins.filter nonEmptyS [ (opt enable debugPortEnv) ]; 
    in ''
      #TODO cannibalized from ghidra launchers
      SCRIPT_FILE="$(readlink -f "$0" 2>/dev/null || readlink "$0" 2>/dev/null || echo "$0")"
      SCRIPT_DIR="''${SCRIPT_FILE%/*}"

      envVars=(${opt (nonEmpty envVars) (withArgs "env" envVars) }) # https://github.com/koalaman/shellcheck/wiki/SC2086
      launcher="$SCRIPT_DIR/../${config.pkg_path}/support/launch.sh"
      launchMode="${
        if enable
          then "debug${opt suspend "-suspend"}"
          else "fg"
          }";
      name=${e name}
      maxMemory=${e maxMemory}
      vmArgs="${vmArgs}" # Note this is unescaped
      class=${e class}
      extraArgs=(${extraArgs}) # Note this is unescaped

      "''${envVars[@]}" "$launcher" "$launchMode" "$name" "$maxMemory" "$vmArgs" "$class" \
        "''${extraArgs[@]}" ${opt enableUserShellArgs ''"$@"''}
      ''

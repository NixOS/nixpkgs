{
  lib,
  writeTextFile,
  writeShellApplication,
  fish-unwrapped,
  completionDirs ? [],
  functionDirs ? [],
  confDirs ? [],
  pluginPkgs ? [],
  localConfig ? "",
  shellAliases ? {},
  runtimeInputs ? []
}:

let
  aliasesStr = builtins.concatStringsSep "\n"
      (lib.mapAttrsToList (k: v: "alias ${k} ${lib.escapeShellArg v}") shellAliases);

  shellAliasesFishConfig = writeTextFile {
    name = "fish-wrapped.aliases.fish";
    destination = "/share/fish/vendor_conf.d/aliases.fish";
    text = ''
      status is-interactive; and begin
        # Aliases
        ${aliasesStr}
      end
    '';
  };

  localFishConfig = writeTextFile {
    name = "fish-wrapped.local.fish";
    destination = "/share/fish/vendor_conf.d/config.local.fish";
    text = localConfig;
  };

  vendorDir = kind: plugin: "${plugin}/share/fish/vendor_${kind}.d";
  complPath = completionDirs ++ map (vendorDir "completions") pluginPkgs;
  funcPath = functionDirs ++ map (vendorDir "functions") pluginPkgs;
  confPath = confDirs
    ++ (map (vendorDir "conf") pluginPkgs)
    ++ (map (vendorDir "conf") [ localFishConfig shellAliasesFishConfig ]);

in writeShellApplication {
  runtimeInputs =
    runtimeInputs
    ++ builtins.concatLists (
      map (plugin: lib.optionals (builtins.hasAttr "deps" plugin) plugin.deps) pluginPkgs
    );
  name = "fish";
  text = ''
    ${fish-unwrapped}/bin/fish --init-command "
      set --prepend fish_complete_path ${lib.escapeShellArgs complPath}
      set --prepend fish_function_path ${lib.escapeShellArgs funcPath}
      set --local fish_conf_source_path ${lib.escapeShellArgs confPath}
      for c in \$fish_conf_source_path/*; source \$c; end
    " "$@"
  '';
  derivationArgs.passthru = {
    inherit (fish-unwrapped) shellPath;
    unwrapped = fish-unwrapped;
  };
}

{ lib, writeShellScriptBin, fish }:

with lib;

makeOverridable ({
  completionDirs ? [],
  functionDirs ? [],
  confDirs ? [],
  pluginPkgs ? []
}:

let
  vendorDir = kind: plugin: "${plugin}/share/fish/vendor_${kind}.d";
  complPath = completionDirs ++ map (vendorDir "completions") pluginPkgs;
  funcPath = functionDirs ++ map (vendorDir "functions") pluginPkgs;
  confPath = confDirs ++ map (vendorDir "conf") pluginPkgs;

in writeShellScriptBin "fish" ''
  ${fish}/bin/fish --init-command "
    set --prepend fish_complete_path ${escapeShellArgs complPath}
    set --prepend fish_function_path ${escapeShellArgs funcPath}
    set --local fish_conf_source_path ${escapeShellArgs confPath}
    for c in \$fish_conf_source_path/*; source \$c; end
  " "$@"
'')

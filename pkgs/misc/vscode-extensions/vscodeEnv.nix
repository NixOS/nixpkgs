#Use vscodeWithConfiguration and vscodeExts2nix to create a vscode executable. When the executable exits, it updates the mutable extension file, which is imported when evaluated by Nix later.
{ lib
, buildEnv
, writeShellScriptBin
, extensionsFromVscodeMarketplace
, vscodeDefault
, jq
}:
##User input
{ vscode                           ? vscodeDefault
, nixExtensions                    ? []
, vscodeExtsFolderName             ? ".vscode-exts"
# will add to the command updateSettings (which will run on executing vscode) settings to override in settings.json file
, settings                         ? {}
, createSettingsIfDoesNotExists    ? true
# will add to the command updateKeybindings(which will run on executing vscode) keybindings to override in keybinding.json file
, keybindings                      ? {}
, createKeybindingsIfDoesNotExists ? true
# if file exists will use it and import the extensions in it into this dervation else will use empty extensions list
# this file will be created/updated by vscodeExts2nix when vscode exists
, mutableExtensionsFile 
}:
let  
  mutableExtensionsFilePath = toString mutableExtensionsFile;
  mutableExtensions = if builtins.pathExists mutableExtensionsFile 
                      then import mutableExtensionsFilePath else [];
  vscodeWithConfiguration = import ./vscodeWithConfiguration.nix { 
    inherit lib writeShellScriptBin extensionsFromVscodeMarketplace;
    vscodeDefault = vscode;
  }
  {
    inherit nixExtensions mutableExtensions vscodeExtsFolderName;
  };

  updateSettings = import ./updateSettings.nix { inherit lib writeShellScriptBin jq; };

  updateSettingsCmd = updateSettings {
    inherit settings;
    createIfDoesNotExists = createSettingsIfDoesNotExists;
  };

  updateKeybindingsCmd = updateSettings {
    settings = keybindings;
    createIfDoesNotExists = createKeybindingsIfDoesNotExists;
    vscodeSettingsFile = ".vscode/keybindings.json";
  };

  vscodeExts2nix = import ./vscodeExts2nix.nix { 
    inherit lib writeShellScriptBin;
    vscodeDefault = vscodeWithConfiguration;
  }
  {
    extensionsToIgnore = nixExtensions;
    extensions = mutableExtensions; 
  };
  code = writeShellScriptBin "code" ''
    ${updateSettingsCmd}/bin/vscodeNixUpdate-settings
    ${updateKeybindingsCmd}/bin/vscodeNixUpdate-keybindings
    ${vscodeWithConfiguration}/bin/code --wait "$@" 
    echo 'running vscodeExts2nix to update ${mutableExtensionsFilePath}...'
    ${vscodeExts2nix}/bin/vscodeExts2nix > ${mutableExtensionsFilePath}
  '';
in
buildEnv {
  name = "vscodeEnv";
  paths = [ code vscodeExts2nix updateSettingsCmd updateKeybindingsCmd ];
}

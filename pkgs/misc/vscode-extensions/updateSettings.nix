# Updates the vscode setting file base on a nix expression
# should run from the workspace root.
{ writeShellScriptBin
, lib
, jq
}:
##User Input
{ settings      ? {}
# if marked as true will create an empty json file if does not exists
, createIfDoesNotExists ? true
, vscodeSettingsFile ? .vscode/settings.json
}:
let
  #VSCode Settings file
  vscodeSettingsFileStr = toString vscodeSettingsFile;

  updateVSCodeSettingsCmd = ''
  (
    echo 'updateSettings.nix: Updating ${vscodeSettingsFileStr}...' 
    oldSettings=$(cat ${vscodeSettingsFileStr})
    echo $oldSettings' ${builtins.toJSON settings}' | ${jq}/bin/jq -s add > ${vscodeSettingsFileStr}
  )'';

  createEmptySettingsCmd = ''mkdir -p .vscode && echo "{}" > ${vscodeSettingsFileStr}'';
in 
  writeShellScriptBin ''vscodeNixUpdate-${lib.removeSuffix ".json" (builtins.baseNameOf vscodeSettingsFileStr)}''
  (lib.optionalString (settings != {}) 
  (if createIfDoesNotExists then ''
    [ ! -f "${vscodeSettingsFileStr}" ] && ${createEmptySettingsCmd}
    ${updateVSCodeSettingsCmd}
  ''
  else ''[ -f "${vscodeSettingsFileStr}" ] && ${updateVSCodeSettingsCmd}''
  ))

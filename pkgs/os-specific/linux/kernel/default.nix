args:
let
  getValue = aSet: aName: default:
  (if (aSet ? aName) then (builtins.getAttr aSet aName) else default);
in

let
  newArgs = (args //
  {
    userModeLinux = getValue args "userModeLinux" false;
  
    localVersion = getValue args "localVersion" "";
  
    config = getValue args "configFile" null;
  
    extraPatches = getValue args "extraPatches" [];
  
    extraConfig = getValue args "extraConfig" [];
  });
in
args.stdenv.lib.listOfListsToAttrs [
  [ "recurseForDerivations" true ]
  [ "2.6.20" (import ./2.6.20.nix newArgs) ]
  [ "2.6.21" (import ./2.6.21.nix newArgs) ]
  [ "2.6.21-ck" (import ./2.6.21-ck.nix newArgs) ]
  [ "2.6.22" (import ./2.6.22.nix newArgs) ]
  [ "2.6.22-ck" (import ./2.6.22-ck.nix newArgs) ]
  [ "2.6.23.1" (import ./2.6.23.1.nix newArgs) ]
]

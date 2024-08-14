{ lib, writeScriptBin, runtimeShell }:

let fake = name: lib.overrideDerivation (writeScriptBin name ''
  #!${runtimeShell}
  echo >&2 "Faking call to ${name} with arguments:"
  echo >&2 "$@"
'') (drv: {
  name = "${name}-stub";
}); in

{
  setfile = fake "SetFile";
  rez = fake "Rez";
  derez = fake "DeRez";
}

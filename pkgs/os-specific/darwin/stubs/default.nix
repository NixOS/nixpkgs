{ stdenv, writeScriptBin }:

let fake = name: stdenv.lib.overrideDerivation (writeScriptBin name ''
  #!${stdenv.shell}
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

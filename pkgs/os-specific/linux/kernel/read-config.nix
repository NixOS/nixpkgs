# Parse Kconfig .config file as an attrset

{ lib }:

configfile:

let
  configRegex = "(CONFIG_[^.]+)=(([^\"]*)|(\".*\"))";
  process = line:
    let
      matches = lib.strings.match configRegex line;
      name = lib.elemAt matches 0;
      valSimple = lib.elemAt matches 2;
      valQuoted = lib.elemAt matches 3;
      value =
        if valSimple == null
        then lib.strings.fromJSON valQuoted
        else valSimple;
    in
      if matches == null
      then [ ]
      else [ { inherit name value; } ];

  lines = lib.strings.splitString "\n" (lib.readFile configfile);
in
  lib.listToAttrs (lib.lists.concatMap process lines)

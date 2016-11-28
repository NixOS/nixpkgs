{ fetchurl, filename }:

let
  data = builtins.fromJSON (builtins.readFile filename);
in pname: fetchurl {url=data.${pname}.url; sha256=data.${pname}.sha256; meta.version=data.${pname}.version;}


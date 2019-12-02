{ runCommand, gawk, lib, extensions, makeWrapper }:

let filtered_ext = with lib;
   filterAttrs (n: v: n != "override" && n != "overrideDerivation" ) extensions;

in
runCommand "gawk-with-extensions" {
  buildInputs = [ makeWrapper gawk ] ++ (builtins.attrValues filtered_ext);
} ''
  mkdir -p $out/bin
  for i in ${gawk}/bin/*; do
    name="$(basename "$i")"
    makeWrapper $i $out/bin/$name \
      --prefix AWKLIBPATH : "${gawk}/lib/gawk:''${AWKLIBPATH:-}"
  done
''

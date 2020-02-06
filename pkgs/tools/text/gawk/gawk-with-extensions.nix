{ runCommand, gawk, extensions, makeWrapper }:

runCommand "gawk-with-extensions" {
  buildInputs = [ makeWrapper gawk ] ++ extensions;
} ''
  mkdir -p $out/bin
  for i in ${gawk}/bin/*; do
    name="$(basename "$i")"
    makeWrapper $i $out/bin/$name \
      --prefix AWKLIBPATH : "${gawk}/lib/gawk:''${AWKLIBPATH:-}"
  done
''

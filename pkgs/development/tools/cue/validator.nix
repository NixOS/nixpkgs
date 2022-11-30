{ cue, writeShellScript, lib }:
cueSchemaFile: { document ? null }:
  writeShellScript "validate-using-cue"
  ''${cue}/bin/cue \
      --all-errors \
      --strict \
      vet \
      --concrete \
      "$1" \
      ${cueSchemaFile} \
      ${lib.optionalString (document != null) "-d \"${document}\""}
  ''

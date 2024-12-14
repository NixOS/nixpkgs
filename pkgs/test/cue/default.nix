{
  writeCueValidator,
  runCommand,
  writeText,
  ...
}:

let
  validator = writeCueValidator (writeText "schema.cue" ''
    #Def1: {
      field1: string
    }
  '') { document = "#Def1"; };
in
runCommand "cue-validation" { } ''
  cat > valid.json <<EOF
  { "field1": "abc" }
  EOF
  cat > invalid.json <<EOF
  { "field2": "abc" }
  EOF
  ${validator} valid.json
  if ${validator} invalid.json; then
    echo "this example should fail"
    exit 1
  fi
  touch $out
''

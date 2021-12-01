{ runCommand
, makeWrapper
, jre
, build-tools
}:
let
  tools = builtins.head build-tools;
in
runCommand "apksigner" {
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper "${jre}/bin/java" "$out/bin/apksigner" \
    --add-flags "-jar ${tools}/libexec/android-sdk/build-tools/${tools.version}/lib/apksigner.jar"
''

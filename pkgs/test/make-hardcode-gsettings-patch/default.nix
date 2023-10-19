{ runCommandLocal
, git
, clang-tools
, makeHardcodeGsettingsPatch
}:

let
  mkTest =
    {
      name,
      expected,
      src,
      schemaIdToVariableMapping,
    }:

    let
      patch = makeHardcodeGsettingsPatch {
        inherit src schemaIdToVariableMapping;
      };
    in
    runCommandLocal
      "makeHardcodeGsettingsPatch-tests-${name}"

      {
        nativeBuildInputs = [
          git
          clang-tools
        ];
      }

      ''
        cp -r --no-preserve=all "${src}" src
        cp -r --no-preserve=all "${expected}" src-expected

        pushd src
        patch < "${patch}"
        popd

        find src -name '*.c' -print0 | while read -d $'\0' sourceFile; do
          sourceFile=''${sourceFile#src/}
          clang-format -style='{BasedOnStyle: InheritParentConfig, ColumnLimit: 240}' -i "src/$sourceFile" "src-expected/$sourceFile"
          git diff --no-index "src/$sourceFile" "src-expected/$sourceFile" | cat
        done
        touch "$out"
      '';
in
{
  basic = mkTest {
    name = "basic";
    src = ./fixtures/example-project;
    schemaIdToVariableMapping = {
      "org.gnome.evolution-data-server.addressbook" = "EDS";
      "org.gnome.evolution.calendar" = "EVO";
      "org.gnome.seahorse.nautilus.window" = "SEANAUT";
    };
    expected = ./fixtures/example-project-patched;
  };
}

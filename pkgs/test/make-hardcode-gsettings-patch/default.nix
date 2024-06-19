{ runCommandLocal
, lib
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
      patches ? [ ],
      schemaIdToVariableMapping,
    }:

    let
      patch = makeHardcodeGsettingsPatch ({
        inherit src schemaIdToVariableMapping;
        inherit patches;
      });
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
        for patch in ${lib.escapeShellArgs (builtins.map (p: "${p}") patches)}; do
            patch < "$patch"
        done
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

  patches = mkTest {
    name = "patches";
    src = ./fixtures/example-project-wrapped-settings-constructor;
    patches = [
      # Avoid using wrapper function, which the generator cannot handle.
      ./fixtures/example-project-wrapped-settings-constructor-resolve.patch
    ];
    schemaIdToVariableMapping = {
      "org.gnome.evolution-data-server.addressbook" = "EDS";
    };
    expected = ./fixtures/example-project-wrapped-settings-constructor-patched;
  };
}

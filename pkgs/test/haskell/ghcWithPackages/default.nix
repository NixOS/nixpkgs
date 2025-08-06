{
  lib,
  runCommand,
  haskellPackages,
}:

lib.recurseIntoAttrs {
  # This is special-cased to return just `ghc`.
  trivial = haskellPackages.ghcWithPackages (hsPkgs: [ ]);

  # Here we actually build a trivial package.
  hello = haskellPackages.ghcWithPackages (hsPkgs: [
    hsPkgs.hello
  ]);

  # Here we build a database with multiple packages.
  multiple = haskellPackages.ghcWithPackages (hsPkgs: [
    hsPkgs.hspec
    hsPkgs.unordered-containers
  ]);

  # See: https://github.com/NixOS/nixpkgs/pull/224542
  regression-224542 =
    runCommand "regression-224542"
      {
        buildInputs = [
          (haskellPackages.ghcWithPackages (hsPkgs: [
            hsPkgs.hspec
          ]))
        ];
      }
      ''
        ghc --interactive \
          -Werror=unrecognised-warning-flags \
          -Werror=missed-extra-shared-lib \
          2>&1 \
        | tee ghc-output.txt

        # If GHC failed to find a shared library, linking dylibs in
        # `ghcWithPackages` didn't work correctly.
        if grep --quiet "error: .*-Wmissed-extra-shared-lib" ghc-output.txt \
          && grep --quiet "no such file" ghc-output.txt; then
          exit 1
        fi

        touch $out
      '';
}

{
  lib,
  runCommand,
  runCommandCC,
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
    let
      ghc = haskellPackages.ghcWithPackages (hsPkgs: [
        hsPkgs.hspec
      ]);
    in
    runCommand "regression-224542"
      {
        nativeBuildInputs = [
          ghc
        ];
      }
      ''
        ${ghc.targetPrefix}ghc --interactive \
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

  use-llvm =
    let
      ghc = (haskellPackages.ghcWithPackages.override { useLLVM = true; }) (_: [ ]);
    in
    runCommandCC "ghc-with-packages-use-llvm"
      {
        nativeBuildInputs = [ ghc ];
      }
      ''
        echo 'main = pure ()' > test.hs
        # -ddump-llvm is unnecessary, but nice for visual feedback in the build log
        ${ghc.targetPrefix}ghc --make -fllvm -keep-llvm-files -ddump-llvm test.hs
        # Did we actually use the LLVM backend?
        test -f test.ll
        touch $out
      '';
}

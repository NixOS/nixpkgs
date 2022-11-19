{ haskell, lib, runCommand }:

let
  ghcSets = lib.filterAttrs
    (name: set:
      !(lib.hasPrefix "ghc92" name) && # TODO: https://github.com/NixOS/nixpkgs/pull/200063
      !(lib.hasPrefix "ghc94" name) && # TODO
      !(lib.hasPrefix "ghcHEAD" name) && # TODO
      set ? ghc && set.ghc ? bootPkgs && !set.ghc.isGhcjs or false
    )
    haskell.packages;

  mkPkg = pkgSet: enableRelocatable:
    haskell.lib.compose.justStaticExecutables (
      pkgSet.callPackage (
        { mkDerivation, ghc }:
        mkDerivation {
          pname = "pathsModule${lib.optionalString enableRelocatable "-reloc"}-ghc-${ghc.version}";
          version = "0.0.0.0";
          src = ./test-pkg;
          inherit enableRelocatable;
          license = lib.licenses.mit;
          doHaddock = false;
        }
      ) { }
    );

  mkTest = pkgSet: relocatable:
    let
      testPkg = mkPkg pkgSet relocatable;
      binPath = "${testPkg}/bin";
    in
      runCommand "test-bindir-output-${testPkg.name}" { } (''
        "${binPath}/pathsModule" | grep "${binPath}"
      '' + lib.optionalString relocatable ''
        cp -r ${binPath}/.. reloc
        ./reloc/bin/pathsModule | grep "$(realpath ./reloc/bin)"
      '' + ''
        touch $out
      '');
in

lib.mapAttrs (_: set: lib.recurseIntoAttrs {
  relocatable = mkTest set true;
  traditional = mkTest set false;
}) ghcSets

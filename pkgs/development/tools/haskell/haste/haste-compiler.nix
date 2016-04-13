{ mkDerivation
, overrideCabal
, super-haste-compiler
}:

overrideCabal super-haste-compiler (drv: {
  configureFlags = [ "-f-portable" ];
  prePatch = ''
    # Get ghc libdir by invoking ghc and point to haste-cabal binary
    substituteInPlace src/Haste/Environment.hs \
      --replace \
        'hasteGhcLibDir = hasteSysDir' \
        'hasteGhcLibDir = head $ lines $ either (error . show) id $ unsafePerformIO $ shell $ run "ghc" ["--print-libdir"] ""' \
      --replace \
        'hasteCabalBinary = hasteBinDir </> "haste-cabal" ++ binaryExt' \
        'hasteCabalBinary = "haste-cabal" ++ binaryExt'

    # Don't try to download/install haste-cabal in haste-boot:
    patch src/haste-boot.hs << EOF
    @@ -178,10 +178,6 @@
                             pkgSysLibDir, jsmodSysDir, pkgSysDir]

           mkdir True (hasteCabalRootDir portableHaste)
    -      case getHasteCabal cfg of
    -        Download    -> installHasteCabal portableHaste tmpdir
    -        Prebuilt fp -> copyHasteCabal portableHaste fp
    -        Source mdir -> buildHasteCabal portableHaste (maybe "../cabal" id mdir)

           -- Spawn off closure download in the background.
           dir <- pwd -- use absolute path for closure to avoid dir changing race
    EOF
  '';
})

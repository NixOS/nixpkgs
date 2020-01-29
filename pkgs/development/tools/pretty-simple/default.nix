{ haskell, haskellPackages, lib }:

haskell.lib.justStaticExecutables (haskell.lib.overrideCabal haskellPackages.pretty-simple (oldAttrs: {
  maintainers = (oldAttrs.maintainers or []) ++ [
    lib.maintainers.cdepillabout
  ];

  configureFlags = (oldAttrs.configureFlags or []) ++ ["-fbuildexe"];

  buildDepends = (oldAttrs.buildDepends or []) ++ [haskellPackages.optparse-applicative];
}))


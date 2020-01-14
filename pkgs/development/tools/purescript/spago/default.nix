{ haskellPackages
, haskell
, lib
}:

haskell.lib.justStaticExecutables (haskell.lib.overrideCabal haskellPackages.spago (oldAttrs: {
  maintainers = (oldAttrs.maintainers or []) ++ [
    lib.maintainers.cdepillabout
  ];

  passthru = (oldAttrs.passthru or {}) // {
    updateScript = ./update.sh;
  };
}))

# This tests that we at least are able to evaluate a ghcjs-based derivation
# to avoid accidental evaluation-related regressions. We can't test actually
# building ghcjs, as it exceeds the output limit on Hydra.
{ haskell, emptyFile }:

builtins.seq haskell.packages.ghcjs.hello.drvPath emptyFile

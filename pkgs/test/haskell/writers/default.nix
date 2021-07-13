# Wrap only the haskell-related tests from tests.writers
# in their own derivation for Hydra CI in the haskell-updates
# jobset. Can presumably removed as soon as tests.writers is
# always green on darwin as well:
# https://github.com/NixOS/nixpkgs/issues/126182
{ runCommand, tests }:

let
  inherit (tests.writers)
    writeTest
    bin
    simple
    ;
in

runCommand "test-haskell-writers" {} ''
  ${writeTest "success" "test-haskell-bin-writer" "${bin.haskell}/bin/${bin.haskell.name}"}
  ${writeTest "success" "test-haskell-simple-writer" simple.haskell}
  touch $out
''

{ pkgs, haskellPackages }: with pkgs.haskell.lib;


let
  drv     = haskellPackages.callCabal2nix "haskell-setBuildTarget" ./. {};
  test    = target: excluded:

    let only = setBuildTarget drv target;
    in ''
         if [[ ! -f "${only}/bin/${target}" ]]; then
           echo "${target} was not built"
           exit 1
         fi

         if [[ -f "${only}/bin/${excluded}" ]]; then
           echo "${excluded} was built, when it should not have been"
           exit 1
         fi
     '';

in pkgs.runCommand "test haskell.lib.setBuildTarget" {} ''
  ${test "foo" "bar"}
  ${test "bar" "foo"}
  touch "$out"
''


{ runCommand, cctools }:
{ haskellPackages, src, deps ? p : [], name }: let
  inherit (haskellPackages) ghc ghcWithPackages;
  with-env = ghcWithPackages deps;
  ghcName = "${ghc.targetPrefix}ghc";
in runCommand name { buildInputs = [ with-env cctools ]; } ''
  mkdir -p $out/lib
  mkdir -p $out/include
  ${ghcName} ${src} -staticlib -outputdir . -o $out/lib/${name}.a -stubdir $out/include
  for file in ${ghc}/lib/${ghcName}-${ghc.version}/include/*; do
    ln -sv $file $out/include
  done
''

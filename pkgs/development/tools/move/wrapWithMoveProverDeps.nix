# This file returns a function for wrapping a package with the Move prover
# dependencies injected into the environment.
# This would generally be used by any downstream consumer of the Move CLI common repository,
# e.g. Aptos or Sui.
{ stdenv
, z3_4_11
, icu
, boogie
, dotnet-sdk
, symlinkJoin
, makeWrapper
}:

let
  z3 = z3_4_11;
in
{ package
, bin
}:

let
  installProver = !stdenv.isi686;
in
if installProver then
  symlinkJoin
  {
    name = "${package.name}-${bin}-with-move-prover-deps";
    paths = [
      package
      z3
      icu
      boogie
      dotnet-sdk
    ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${bin} \
        --set Z3_EXE ${z3}/bin/z3 \
        --set DOTNET_ROOT ${dotnet-sdk} \
        --set LD_LIBRARY_PATH ${icu}/lib \
        --set BOOGIE_EXE ${boogie}/bin/boogie
    '';
  } else package

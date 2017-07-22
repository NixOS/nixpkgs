{ stdenv, ghcWithPackages, makeWrapper, packages }:

let
hyperHaskellEnv = ghcWithPackages (self: [ self.hyper-haskell-server ] ++ packages self);
in stdenv.mkDerivation {
  name = "hyper-haskell-server-with-packages";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${hyperHaskellEnv}/bin/hyper-haskell-server $out/bin/hyper-haskell-server \
      --set NIX_GHC ${hyperHaskellEnv}/bin/ghc \
      --set NIX_GHCPKG ${hyperHaskellEnv}/bin/ghc-pkg \
      --set NIX_GHC_LIBDIR ${hyperHaskellEnv}/lib/ghc-*
  '';

  # trivial derivation
  preferLocalBuild = true;
  allowSubstitutes = false;
}

{ stdenv, ghcWithPackages, makeWrapper, packages, lib }:

let
hyperHaskellEnv = ghcWithPackages (self: [ self.hyper-haskell-server ] ++ packages self);
in stdenv.mkDerivation {
  pname = "hyper-haskell-server-with-packages";
  version = hyperHaskellEnv.version;

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

  meta = {
    # Marked as broken because the underlying
    # haskellPackages.hyper-haskell-server is marked as broken.
    hydraPlatforms = lib.platforms.none;
    broken = true;
  };
}

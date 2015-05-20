{ mkDerivation, fetchgit, aeson, base, bytestring, Cabal, containers
, deepseq, deepseq-generics, directory, doctest, filepath, gitMinimal
, hackage-db, hspec, lens, monad-par, monad-par-extras, mtl, pretty
, process, QuickCheck, regex-posix, SHA, split, stdenv, transformers
, utf8-string, cartel, nix-prefetch-scripts, makeWrapper
}:

mkDerivation rec {
  pname = "cabal2nix";
  version = "20150518";
  src = fetchgit {
    url = "http://github.com/NixOS/cabal2nix.git";
    rev = "bf850da9044b16efb9ef06a05c645fa981513444";
    sha256 = "0kwiwakff1iaglf7mfvz096smqi73pgcfd975dvp5w1cd8yazd73";
    deepClone = true;
  };
  isExecutable = true;
  enableSharedLibraries = false;
  enableSharedExecutables = false;
  buildDepends = [
    aeson base bytestring Cabal containers deepseq-generics directory
    filepath hackage-db lens monad-par monad-par-extras mtl pretty
    process regex-posix SHA split transformers utf8-string cartel
  ];
  testDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hspec lens monad-par
    monad-par-extras mtl pretty process QuickCheck regex-posix SHA
    split transformers utf8-string
  ];
  buildTools = [ gitMinimal makeWrapper ];
  preConfigure = "runhaskell $setupCompileFlags generate-cabal-file --release >cabal2nix.cabal";
  postInstall = ''
    exe=$out/libexec/${pname}-${version}/cabal2nix
    install -D $out/bin/cabal2nix $exe
    rm -rf $out/{bin,lib,share}
    makeWrapper $exe $out/bin/cabal2nix --prefix PATH ":" "${nix-prefetch-scripts}/bin"
  '';
  homepage = "http://github.com/NixOS/cabal2nix/";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
}
